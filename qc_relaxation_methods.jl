# using PowerModels
using JuMP
using Suppressor
import Ipopt
#TODO: move RCall to run_qc_relax
@suppress using RCall # use RCall since hitandrun has an efficient implementation there,
## the prefered Julia lib would be MAMBA but it does not have this sampling. See:
## https://mambajl.readthedocs.io/en/latest/samplers.html?highlight=sample#sampling-functions

const TOLERANCE = 1e-4;

# ================ module begin ===============================
function create_pol(N::Integer)
"""Create N-dim unit cube."""
    rSTDO = R"""
    library(volesti)
    P <- gen_cube($N,'H')
    P$b <- cbind(matrix(0,1,$N), matrix(1,1,$N))
    """ # mondify cube from [-1 1] to [0 1]
    return rcopy(R"P$A"),rcopy(R"P$b")
end

function create_scaled_pol(N::Integer,U::AbstractArray)
"""Create polytope with increased upper bounds."""
    rSTDO = R"""
    library(volesti)
    P <- gen_cube($N,'H')
    P$b <- cbind(matrix(0,1,$N), matrix(c(unlist($U)),1,$N))
    """ # mondify cube from [-1 1] to [0 1]
    return rcopy(R"P$A"),rcopy(R"P$b")
end

function add_to_pol(Al::AbstractArray,bl::Union{AbstractArray{<:Number},Number})
    R"""
    P$A <- rbind(P$A, $Al)
    P$b <- c(P$b, $bl)"""
    nothing
end

function get_pol()
    A = rcopy(R"P$A")
    b = rcopy(R"P$b")
    return A::Array{Float64,2}, b::Union{AbstractArray{<:Number},Number}
end

function sample_pol(number_of_samples::Integer=1)
    samples = rcopy(R"sample_points(P, $number_of_samples)")
    return samples::Array{Float64,2}
end

function get_pol_volume()
    vol = rcopy(R"volume(P)")
    return vol::Number
end

function sample_polyhedron(N::Integer,A::AbstractArray=[],b::AbstractArray=[])
"""Get N number of uniformly distributed samples from the convex polytope
    defined by A and b. The polytope is most likely defined in the R session
    already. If A and b are not given just call sample_pol"""
    if ~isempty(A)
        # define polytope by A and b using R call
    end
    samples = transpose(sample_pol(N))
    return samples::AbstractArray
end
# ================ module end ===============================

function tt(v, A)
"""General purpose method that implements NxM matrix multiply by 1xM vector, so
    that each column of the matrix is multiplied by the corresponding value of
    the vector."""
    r = similar(A)
    @inbounds for j = 1:size(A,2)
        @simd for i = 1:size(A,1)
            r[i,j] = v[j] * A[i,j]
        end
    end
    r
end


function get_header_names(variables::AbstractArray)
    header = [] # used as header in x_opt results csv
    push!(header, JuMP.name.(variables))
    header = map((x) -> uppercase(replace(x, r"0_|\[|\]" => "")),header[1]) # prettify
    return [header]::AbstractArray
end

function get_slack_idx(power_model::AbstractPowerModel)
    # Slack type == 3
    bus_idx =  [k for (k,v) in power_model.data["bus"] if v["bus_type"] == 3]
    bus_idx = parse(Int64,bus_idx[1])
    gen_idx = [k for (k,v) in power_model.data["gen"] if v["gen_bus"] == bus_idx]
    return parse(Int64, gen_idx[1])
end

function run_qc_relax(pm::AbstractPowerModel, number_of_iterations::Integer, vol::Integer=0)
    """ Iteratively solve modified QC-AC-OPF
    inputs: power model and number of iterations"""
    # Initialize variables
    start = time();
    info(logger,"QC relaxation tolerance set to $TOLERANCE .")
    optimal_setpoints = []
    vars = []
    # build optimization problem
    # get variables: PG\{slack} and Vm (all generators)
    # slack: bus_type == 3
    #
    # to get all: vars = [pm.var[:nw][0][:pg].data; pm.var[:nw][0][:vm].data];
    #
    slack_gen_idx = get_slack_idx(pm)
    for i=1:length(pm.var[:nw][0][:pg].data)
        if i != slack_gen_idx
            push!(vars, JuMP.variable_by_name(pm.model, string("0_pg[",i,"]")))
        end
    end
    gen_indexes = map(x -> x["gen_bus"], values(pm.data["gen"]))
    for g in gen_indexes
        push!(vars, JuMP.variable_by_name(pm.model, string("0_vm[",g,"]")))
    end
    # extract header names
    header = get_header_names(vars) # call before normalization

    N = length(vars);
#TODO: Currently the variables of the optimization problem are scaled between
# [0;1] so we sample from a unit cube. if create_scaled_pol() is used the polytope
# polytope gets scaled and we can remove the scaling of the vars. This later
# might prove to be the proper solution as I could not make sure that scaling
# only vars is sufficient.
    nFactor = JuMP.upper_bound.(vars)
    # auxiliary variables to bridge AffExpr <-> NLconstraint
    #   See "Syntax notes" http://www.juliaopt.org/JuMP.jl/dev/nlp/#Nonlinear-Modeling-1)
    @variable(pm.model,aux[1:N])
    @constraint(pm.model,aux .== vars./nFactor)
    vars = vars./nFactor; # normalize after aux is defined

    # Create x_hat random sample
    create_pol(N) # Create initial unit cube
    x_hat = sample_pol() # Initial sample from N unit cube

    # Build optimization problem
    # Alter the QCCR problem
    @variable(pm.model, r);
    @objective(pm.model, Min, r);
    @NLparameter(pm.model, x_hat_p[i = 1:N] == x_hat[i]) # updating the parameter has performance gain vs rebuilding the model
    @NLconstraint(pm.model, con_sphere, sqrt(sum((aux[i]-x_hat_p[i])^2 for i in 1:N))<= r);

    debug(logger,"number of it: $number_of_iterations")
    for k = 1:number_of_iterations # Julia for loop has it's own scope, x_hat not accessible
        # Execute optimization
        result = optimize_model!(pm, optimizer=optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))
        # Calculate outputs
        x_opt = JuMP.value.(vars);
        n_normT = transpose(x_opt[:] - x_hat); # This can be simply -> objective_value(pm.model) NO, in the article that is not abs() but l^1 norm
        debug(logger,string("Objective_value: " ,JuMP.value(r)))
        push!(optimal_setpoints, (x_opt[:] .* nFactor)' )
        if !(isapprox(JuMP.value(r), 0; atol=TOLERANCE))
            # Update results
            add_to_pol(n_normT, n_normT*x_opt)
            debug(logger,string("Polytope values |get_pol() \n", get_pol() ))
        end
        try
            x_hat = sample_pol()
            debug(logger,"New points sampled.")
        catch e
            debug(logger,typeof(e))
            debug(logger,e)
            return A,b
        end
        if vol > 0
            if k % vol == 0 || k == 1
                # save file
                A,b = get_pol()
                if k == 1
                    writedlm(string("polytope_A_",0,".csv"), A, ',')
                    writedlm(string("polytope_b_",0,".csv"), b, ',')
                else
                    writedlm(string("polytope_A_",k,".csv"), A, ',')
                    writedlm(string("polytope_b_",k,".csv"), b, ',')
                end
            end
        end
        # print("Volume: ", get_volume(N,A,b))
        JuMP.set_value.(x_hat_p, x_hat)
        debug(logger,"New x_hat JuMP parameter values set.")
    end
    A,b = get_pol()
    debug(logger,"Return polytope.")
    debug(logger, string("Variable Names: ", header))
    return A,b,optimal_setpoints,header,nFactor
end

function mod_acopf!(pm::AbstractPowerModel)
"""Modify the objective function and add NL constraint to AC-OPF problem."""
    vars = []
    slack_gen_idx = get_slack_idx(pm)
    for i=1:length(pm.var[:nw][0][:pg].data)
        if i != slack_gen_idx
            push!(vars, JuMP.variable_by_name(pm.model, string("0_pg[",i,"]")))
        end
    end
    gen_indexes = map(x -> x["gen_bus"], values(pm.data["gen"]))
    for g in gen_indexes
        push!(vars, JuMP.variable_by_name(pm.model, string("0_vm[",g,"]")))
    end
    pm.model[:vars] = vars;
    N = length(vars);
    x_hat = zeros(1,N);

    @variable(pm.model, r);
    @objective(pm.model, Min, r);
    @NLparameter(pm.model, x_hat_p[i = 1:N] == x_hat[i]) # current row of samples
    pm.model[:x_hat_p] = x_hat_p;

    @NLconstraint(pm.model, con_sphere,
        sqrt(sum((vars[i]-x_hat_p[i])^2 for i in 1:N))<= r);

    return nothing
end

function run_mod_acopf(pm::AbstractPowerModel,sp::AbstractArray)
    """Run modified ACOPF with setpoints defined by sp"""
    power_model = pm; # do not modify original model
    JuMP.set_value.(power_model.model[:x_hat_p],sp)
    result = optimize_model!(power_model, optimizer=optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))

    return JuMP.value.(power_model.model[:vars])
end
