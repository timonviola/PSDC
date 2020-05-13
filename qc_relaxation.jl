using PowerModels
using Ipopt
using DelimitedFiles
using Memento
using ArgParse
include("qc_relaxation_methods.jl")

function parse_cli()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "case_file_name"
            help = "Case file name (relative or full path with extension).
            Supported file formats:\n\t- matpower v2.0"
            required = true
        "case_file_name_tightened"
            help = "Tightened output case file name (relative or full path with
            extension). Supported file formats:\n\t- matpower v2.0"
            required = true
        "number_of_iterations"
            help = "Number of polytopes added."
            arg_type = Int
            required = true
        "out_file_name_A"
            help = "Output file of the convex polytope's A matrix. File fullpath
            should be defined including the extension (.csv)."
            required = true
        "out_file_name_B"
            help = "Output file of the convex polytope's b vector. File fullpath
            should be defined including the extension (.csv)."
            required = true
        "out_file_name_X"
            help = "Output file of optimal set points. The first row contains the
            variable names."
            required = true
        "--log", "-l"
            help = "Define log level. Possible values are: [debug | info |
            notice | warn | error]."
            arg_type = String
            default = "info"
    end

    return parse_args(s)
end


function main()
    """ Run N number of iterations that executes a modified QC relaxed ACOPF to created
        separating hyper-planes and event reduce."""

    parsed_inputs = parse_cli()
    # Logger settings
    # Silence all: PowerModels.silence()
    logger = Memento.config!(parsed_inputs["log"]; fmt="[{level} | {name}]: {msg}")
    Memento.setlevel!(Memento.getlogger(PowerModels.InfrastructureModels), "error")
    if parsed_inputs["log"] == "debug"
        # enable debug:
        ENV["JULIA_DEBUG"] = "all"
    end

    # Input data: number of iterations , model name
    debug(logger, string("ARGS: ", parsed_inputs))

    start = time();
    # Load network data from file
    Memento.setlevel!(Memento.getlogger(PowerModels), "error")
    network_data = PowerModels.parse_file(parsed_inputs["case_file_name"])
    Memento.setlevel!(Memento.getlogger(PowerModels), "info")
    # Run bound tightening
    info(logger, string("Run obbt for ", parsed_inputs["case_file_name"],"."))
    network_data_tight, stats = PowerModels.run_obbt_opf!(network_data,
        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0);
        model_constructor=ACPPowerModel, max_iter=1, time_limit=120.0);
    #TODO: set max_iter to 3-4 on production version
    warn(logger,"obbt opf max_iter should be set to higher!")
    # MATPOWER export
    # update original data with solution
    update_data!(network_data, network_data_tight) #network_data_tight["solution"]
    f = open(parsed_inputs["case_file_name_tightened"],"w")
    export_matpower(f,network_data)
    close(f)


    # Initialize abstract power system model
    power_model = instantiate_model(network_data_tight, ACPPowerModel, PowerModels.build_opf)

    info(logger,string("Run QC relaxation for, ",  parsed_inputs["case_file_name"],"."))
    A_out,b_out,x_opt,header = run_qc_relax(power_model, parsed_inputs["number_of_iterations"])


    # Write results to file
    info(logger,string("Output files written:\n\t- ", parsed_inputs["out_file_name_A"],
                        "\n\t- ", parsed_inputs["out_file_name_B"],
                        "\n\t- ", parsed_inputs["out_file_name_X"],"."))
    writedlm(parsed_inputs["out_file_name_A"], A_out, ',')
    writedlm(parsed_inputs["out_file_name_B"], b_out, ',')

    writedlm(parsed_inputs["out_file_name_X"], header, ',')
    open(parsed_inputs["out_file_name_X"],"a") do io
        writedlm(io, x_opt, ',')
    end

    elapsed = time() - start
    info(logger,"Elapsed time: $elapsed sec .")
end

logger = Memento.config!("info"; fmt="[{level} | {name}]: {msg}")
main()
