function time = hpc_eig_test(A)

startTime = tic;
parfor i = 1:200
    a(i) = max(abs(eig(rand(A))));
end
time = toc(startTime);

end