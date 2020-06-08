input_file = [OUT_DIR filesep FILE_NAME_SAMPLES];
case_file = ['case_files' filesep CASE_NAME '.m'];
output_fname = [OUT_DIR filesep CASE_NAME '_ACOPF.csv'];


fileID = fopen([OUT_DIR filesep 'j_opf.sh'],'w');
writeSH(fileID)

fprintf(fileID, strrep(['julia -p 4 opf_par.jl "' output_fname '" "' ...
    case_file '" "' input_file '"'],'\','/'));

fclose(fileID);

disp('Run:')
disp(['bsub < ' strrep([OUT_DIR, filesep], '\','/') 'j_opf.sh'])

function writeSH(fid)
sh_cont = [...
    "#!/bin/sh"
    "#BSUB -q elektro"
    "#BSUB -J j_opf_par"
    "#BSUB -W 02:00"
    "#BSUB -n 10"
    '#BSUB -R "rusage[mem=8GB]"'
    "#BSUB -N"
    "#BSUB -o out_temp_%J.txt"
    "#BSUB -e error_temp_%J.txt"
    ""
    "module load julia/1.1.1"
];

fprintf(fid, '%s\n', sh_cont);

end

