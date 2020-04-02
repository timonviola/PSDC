function time = hpcEigTest(A)

startTime = tic;
parfor i = 1:200
    a(i) = max(abs(eig(rand(A))));
end
time = toc(startTime);

end