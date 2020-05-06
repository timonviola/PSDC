using PowerModels
using Ipopt
using DelimitedFiles
using Memento
include("qc_relaxation_methods.jl")


""" Run N number of iterations that executes a modified QC relaxed ACOPF to created
    separating hyper-planes and event reduce."""
# set logger
#PowerModels.silence()
const LOGLEVEL = "info"
Memento.setlevel!(Memento.getlogger(PowerModels.InfrastructureModels), "error")
logger = Memento.config!(LOGLEVEL; fmt="[{level} | {name}]: {msg}")
if LOGLEVEL == "debug"
    # enable debug:
    ENV["JULIA_DEBUG"] = "all"
end
# Input data: number of iterations , model name


debug(logger, "Input args:")
const matpower_file_name = "case14.m";#ARGS[1];#"case14.m"
const number_of_iterations = 1#parse(Int64, ARGS[2]);#200
if length(ARGS) > 2
    out_file_name_A = ARGS[3]
else
    out_file_name_A = "A_lhs_mat22.csv"
end
if length(ARGS) > 3
    out_file_name_B = ARGS[4]
else
    out_file_name_B = "b_rhs_vec22.csv"
end
@debug ARGS


const start = time();
# Load network data from file
network_data = PowerModels.parse_file(matpower_file_name)

# Run bound tightening
info(logger, "Run obbt for $matpower_file_name.")
network_data_tight, stats = PowerModels.run_obbt_opf!(network_data,
    optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0);
    model_constructor=ACPPowerModel, max_iter=1, time_limit=120.0);
#update_data!(network_data,network_data_tight)

# Initialize abstract power system model
power_model = instantiate_model(network_data_tight, ACPPowerModel, PowerModels.build_opf)

info(logger,"Run QC relaxation for $matpower_file_name.")
A_out,b_out = run_qc_relax(power_model, number_of_iterations)



# Write results to file
info(logger,"Output files written:\n\t- $out_file_name_A \n\t- $out_file_name_B.")
writedlm( out_file_name_A,  A_out, ',')
writedlm( out_file_name_B,  b_out, ',')

elapsed = time() - start
info(logger,"Elapsed time: $elapsed sec .")

# Julia/REPL has some issues with scoping which actually not that starightforward
# https://discourse.julialang.org/t/new-scope-solution/16707/227
