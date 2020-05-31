using Distributed
addprocs(2)
println(string("Number of procs:", nprocs()))

@everywhere begin
    using PowerModels
    using Suppressor
    using Ipopt
    using Memento
    # using SharedArrays
    using JuMP
end
using ArgParse
using DelimitedFiles

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

@everywhere function run_mod_acopf(pm::AbstractPowerModel,sp::AbstractArray)
    """Run modified ACOPF with setpoints defined by sp"""
    power_model = pm; # do not modify original model
    JuMP.set_value.(power_model.model[:x_hat_p],sp)
    @suppress_out result = optimize_model!(power_model, optimizer=optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0))

    return JuMP.value.(power_model.model[:vars])
end


function parse_cli()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "--log", "-l"
            help = "Define log level. Possible values are: [debug | info |
            notice | warn | error]."
            arg_type = String
            default = "info"
        "out_file_name"
            help = "Output file containing the Pg and Vg values of the sovled
            AC-OPFs."
            required = true
        "case_file_name"
            help = "Case file name (relative or full path with extension).
            Supported file formats:\n\t- matpower v2.0"
            required = true
        "samples"
            help = ".csv file containing the samples from the convex polytope
            of several QC relaxation runs."
            required = true
    end

    return parse_args(s)
end

function main()
"""Solve AC-OPF for each point in the data set defined by SAMPLES and save the
resulting optimal scenarios' Pg, Vg values."""
    logger = Memento.config!("info"; fmt="[{level} | {name}]: {msg}")

    parsed_inputs = parse_cli()
    start = time();
    samples_file_name = parsed_inputs["samples"]#string(pwd(), "\\case14_results4.csv")
    case_file_name = parsed_inputs["case_file_name"]#string(pwd(), "\\case14.m")
    out_file_name = parsed_inputs["out_file_name"]#string(pwd(), "\\n24_case14_acopf.csv")

    debug(logger,"Inputs parsed.")
    logger = Memento.config!(parsed_inputs["log"]; fmt="[{level} | {name}]: {msg}")
    Memento.setlevel!(Memento.getlogger(PowerModels.InfrastructureModels), "error")
    if parsed_inputs["log"] == "debug"
        # enable debug:
        ENV["JULIA_DEBUG"] = "all"
    end

    # Load .csv (already scaled) setpoint add_arg_table
    samples = readdlm(samples_file_name,',', Float64, header=true)
    sSamples = size(samples[1]);
    info(logger,string("Executing for ",sSamples[1], " setpoints."))
    # Load matpower case14
    network_data = PowerModels.parse_file(case_file_name)#parsed_inputs["case_file_name"])

    # Initialize abstract power system model
    power_model = instantiate_model(network_data, ACPPowerModel,
        PowerModels.build_opf)

    # to display the obj func: JuMP.objective_function(power_model.model)
    # to check on named constraint: power_model.model[:con_sphere]
    mod_acopf!(power_model)

    M = [samples[1][i,:] for i=1:sSamples[1]]
    info(logger,string("Start parallel run."))
    res = pmap(x -> run_mod_acopf(power_model,x), M)

    elapsed = time() - start

    info(logger,string("Finished. Elapsed time: $elapsed sec ."))
    # map to Array
    out = Array{Float64}(undef,sSamples);
    for i=1:sSamples[1]
        out[i,:] = res[i]
    end
    info(logger,string("Writing output file $out_file_name."))
    header = get_header_names(power_model.model[:vars])
    writedlm(out_file_name, header, ',')
    open(out_file_name,"a") do io
        writedlm(io, out, ',')
    end
end

main()
