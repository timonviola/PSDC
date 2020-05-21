using PowerModels
using Ipopt
using DelimitedFiles
using Memento
using ArgParse
include("qc_relaxation_methods.jl")

function parse_cli()
    s = ArgParseSettings()
    @add_arg_table! s begin
        "--log", "-l"
            help = "Define log level. Possible values are: [debug | info |
            notice | warn | error]."
            arg_type = String
            default = "info"
        "--tightened", "-t"
            help = "Tightened output case file name (relative or full path with
            extension). Supported file formats:\n\t- matpower v2.0"
            arg_type = String
        "--out_file_name_A", "-A"
            help = "Output file of the convex polytope's A matrix. File fullpath
            should be defined including the extension (.csv)."
            arg_type = String
        "--out_file_name_B", "-b"
            help = "Output file of the convex polytope's b vector. File fullpath
            should be defined including the extension (.csv)."
        "--out_file_name_X", "-x"
            help = "Output file of optimal set points. The first row contains the
            variable names."
            arg_type = String
        "case_file_name"
            help = "Case file name (relative or full path with extension).
            Supported file formats:\n\t- matpower v2.0"
            required = true
        "number_of_iterations"
            help = "Number of polytopes added."
            arg_type = Int
            required = true
        "out_samples_file_name"
            help = "Output file containing N2 number of uniform samples from the
            convex polytope. File fullpath should be defined including the
            extension (.csv)."
            arg_type = String
            required = true
        "n2_number_of_samples"
            help = "N2 number of samples from the convex polytope."
            arg_type = Int
            required = true
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

    # suppress Ipopt message
    local network_data_tight, stats
    @suppress_out network_data_tight, stats = PowerModels.run_obbt_opf!(network_data,
        optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0);
        model_constructor=ACPPowerModel, max_iter=1, time_limit=120.0);

    #TODO: set max_iter to 3-4 on production version
    warn(logger,"obbt opf max_iter should be set to higher!")
    # MATPOWER export
    # update original data with solution

    if parsed_inputs["tightened"] != nothing
        info(logger, string("Writing tightened case file: ", parsed_inputs["tightened"],"."))
        update_data!(network_data, network_data_tight) #network_data_tight["solution"]
        f = open(parsed_inputs["tightened"],"w")
        export_matpower(f,network_data)
        close(f)
    end

    # Initialize abstract power system model
    #TODO: I think ACPPowerModel is the acopf formulation and PowerModels.QCRMPowerModel is the quadratic relaxation
    # ref: https://lanl-ansi.github.io/PowerModels.jl/stable/formulation-details/#Formulation-Details-1
    power_model = instantiate_model(network_data_tight, QCRMPowerModel, PowerModels.build_opf)

    info(logger,string("Run QC relaxation for, ",  parsed_inputs["case_file_name"],"."))
    A_out,b_out,x_opt,header,scaling_factor = run_qc_relax(power_model, parsed_inputs["number_of_iterations"])
    debug(logger,string("scaling_factor",scaling_factor))


    if parsed_inputs["out_file_name_A"] != nothing
        info(logger,string("Write file:\n\t- ", parsed_inputs["out_file_name_A"]))
        writedlm(parsed_inputs["out_file_name_A"], A_out, ',')
    end
    if parsed_inputs["out_file_name_B"] != nothing
        info(logger,string("Write file:\n\t- ", parsed_inputs["out_file_name_B"]))
        writedlm(parsed_inputs["out_file_name_B"], b_out, ',')
    end
    if parsed_inputs["out_file_name_X"] != nothing
        writedlm(parsed_inputs["out_file_name_X"], header, ',')
        open(parsed_inputs["out_file_name_X"],"a") do io
            writedlm(io, x_opt, ',')
        end
    end

    info(logger,string("Sample ",  parsed_inputs["n2_number_of_samples"]," points."))
    N2_out = sample_polyhedron(parsed_inputs["n2_number_of_samples"])
    N2_scaled = tt(scaling_factor,N2_out)
    writedlm(parsed_inputs["out_samples_file_name"], header, ',')
    open(parsed_inputs["out_samples_file_name"],"a") do io
        writedlm(io, N2_scaled, ',')
    end

    elapsed = time() - start
    info(logger,"Elapsed time: $elapsed sec .")
end

logger = Memento.config!("info"; fmt="[{level} | {name}]: {msg}")
main()
