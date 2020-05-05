using PowerModels
using JuMP
using Ipopt
using RCall # use RCall since hitandrun has an efficient implementation there,
## the prefered Julia lib would be MAMBA but it does not have this sampling. See:
## https://mambajl.readthedocs.io/en/latest/samplers.html?highlight=sample#sampling-functions
using Random
using DelimitedFiles

function get_volume(N,A_j,b_j)
    rSTDO = R"""
        library(volesti)
        A <- matrix(unlist($A_j), ncol = $N, byrow=TRUE)
        b <- c(unlist($b_j))
        P = Hpolytope$new(A,b)
        volume(P)
    """
    return rcopy(rSTDO)
end

function sample_Rpoints(N,A_j=[],b_j=[])
    """Uniform sampling from a convex polytope using R-volesti lib"""
    if (isempty(A_j))
        rSTDO = R"""
            library(volesti)
            A <- rbind(diag($N), -diag($N))
            b <- cbind(matrix(1,1,$N), matrix(0,1,$N))
            P = Hpolytope$new(A,b)
            sample_points(P,N=1)
        """
        A_j = rcopy(R"A")
        b_j = rcopy(R"b")
        return rcopy(rSTDO), A_j, b_j
    else
        println("before sampling points")
        rSTDO = R"""
            library(volesti)
            A <- matrix(unlist($A_j), ncol = $N, byrow=TRUE)
            b <- c(unlist($b_j))
            P = Hpolytope$new(A,b)
            sample_points(P,N=1)
        """
        return rcopy(rSTDO)
    end
end

function run_qc_relax(pm, number_of_iterations)
    """ Iteratively solve modified QC-AC-OPF
    inputs: power model and number of iterations"""
    # Initialize variables
    start = time();

    # build optimization problem
    vars = [pm.var[:nw][0][:pg].data; pm.var[:nw][0][:vm].data];
    N = length(vars);
    nFactor = JuMP.upper_bound.(vars) - JuMP.lower_bound.(vars);
    #vars = vars./nFactor; # normalize
    # auxiliary variables to bridge AffExpr <-> NLconstraint
    #   See "Syntax notes" http://www.juliaopt.org/JuMP.jl/dev/nlp/#Nonlinear-Modeling-1)
    @variable(pm.model,aux[1:N])
    @constraint(pm.model,aux .== vars./nFactor)
    vars = vars./nFactor; # normalize after aux is defined

    # Create x_hat random sample
    x_hat,A,b = sample_Rpoints(N) #Initial sample from N unit cube
    print("Volume: ",get_volume(N,A,b))
    # Build optimization problem
    # Alter the QCCR problem
    @variable(pm.model, r);
    @objective(pm.model, Min, r);
    @NLparameter(pm.model, x_hat_p[i = 1:N] == x_hat[i]) # updating the parameter has performance gain vs rebuilding the model
    @NLconstraint(pm.model, con_sphere, sqrt(sum((aux[i]-x_hat_p[i])^2 for i in 1:N))<= r);
    print("number of it: ", number_of_iterations)
    for k = 1:number_of_iterations # Julia for loop has it's own scope, x_hat not accessible
        # Execute optimization
        result = optimize_model!(pm, optimizer=optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
        # Calculate outputs
        x_opt = JuMP.value.(vars);
        n_normT = transpose(x_opt[:] - x_hat); # This can be simply -> objective_value(pm.model) NO, in the article that is not abs() but l^1 norm
        println(JuMP.value(r))

        if (isapprox(JuMP.value(r), 0; atol=TOLERANCE))
            # Update results
            A = [A; n_normT]
            b = [b[:]; n_normT*x_opt]
        end
        println(size(A))
        println(size(b))
        x_hat = sample_Rpoints(N, A, b);
        println("points sampled")
        # print("Volume: ", get_volume(N,A,b))
        JuMP.set_value.(x_hat_p, x_hat)
        println("jump value set")
    end
    # println("Volume calculation...")
    # print("Volume: ",get_volume(N,A,b))
    return A,b
end


""" Run N number of iterations that executes a modified QC relaxed ACOPF to created
    separating hyper-planes and event reduce."""
# TODO: Julia argparse - write help
# Input data: number of iterations , model name
matpower_file_name = "case14.m"#ARGS[1];
number_of_iterations = 1000#parse(Int64, ARGS[2]);
TOLERANCE = 1e-4

start = time();
# Load network data from file
network_data = PowerModels.parse_file(matpower_file_name)

# Run bound tightening
network_data_tight, stats = PowerModels.run_obbt_opf!(network_data,
    optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0);
    model_constructor=ACPPowerModel, max_iter=1, time_limit=120.0);
#update_data!(network_data,network_data_tight)

# Initialize abstract power system model
power_model = instantiate_model(network_data_tight, ACPPowerModel, PowerModels.build_opf)

A_out,b_out = run_qc_relax(power_model, number_of_iterations)



# Write results to file
writedlm( "A_lhs_mat2.csv",  A_out, ',')
writedlm( "b_rhs_vec2.csv",  b_out, ',')
elapsed = time() - start
print(string("elapsed time: ", elapsed, " seconds"))

# Julia/REPL has some issues with scoping which actually not that starightforward
# https://discourse.julialang.org/t/new-scope-solution/16707/227
