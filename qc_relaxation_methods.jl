# using PowerModels
using JuMP
import Ipopt
using RCall # use RCall since hitandrun has an efficient implementation there,
## the prefered Julia lib would be MAMBA but it does not have this sampling. See:
## https://mambajl.readthedocs.io/en/latest/samplers.html?highlight=sample#sampling-functions

const TOLERANCE = 1e-4;

# ================ module begin ===============================
function create_pol(N::Integer)
    rSTDO = R"""
    library(volesti)
    P <- GenCube($N,'H')
    """
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
    samples = rcopy(R"sample_points(P,N=$number_of_samples)")
    return samples::Array{Float64,2}
end

function get_pol_volume()
    vol = rcopy(R"volume(P)")
    return vol::Number
end
# ================ module end ===============================

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

function run_qc_relax(pm::AbstractPowerModel, number_of_iterations::Integer)
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

        # print("Volume: ", get_volume(N,A,b))
        JuMP.set_value.(x_hat_p, x_hat)
        debug(logger,"New x_hat JuMP parameter values set.")
    end
    A,b = get_pol()
    debug(logger,"Return polytope.")
    @info(logger,header)
    return A,b,optimal_setpoints,header
end
