ACOPF_SEED = '.data/case14_ACOPF.csv';
acopfResults = readtable(ACOPF_SEED, 'ReadVariableNames',true);
acopfResults = acopfResults(:,sort(acopfResults.Properties.VariableNames));
X = acopfResults{1,:};
X2 = acopfResults{2,:};

N = 10000;
fprintf([pad('_',60,'_'), '\n'])
fprintf('<strong>Speed test: N-dim Eucledian norm</strong>\n')
fprintf('Test vector dim:\t%d\n',size(X,2))
fprintf('Average of %d calls\n',N)


% method #1
fprintf(pad('Y = sqrt(sum(X .* X))',50,'right','.'))
t = tic;
Y = sqrt(sum(X .* X2));
single = sprintf('%3.6f',toc(t));

tv = nan(1,N);

for i = 1:N
    t = tic;
    Y = sqrt(sum(X .* X2));
    tv(i) = toc(t);   
end
avg = sum(tv)/N;

fprintf(' [ OK ]\n')
fprintf('\tsingle:\t\t%s s\n',single);
fprintf('\taverage:\t%3.6f s\n\n',avg);

% method #2
fprintf(pad("Y = sqrt(X * X2')",50,'right','.'))
t = tic;
Y = sqrt(X * X2');
single = sprintf('%3.6f',toc(t));

tv = nan(1,N);
for i = 1:N
    t = tic;
    Y = sqrt(X * X2');
    tv(i) = toc(t);   
end
avg = sum(tv)/N;

fprintf(' [ OK ]\n')
fprintf('\tsingle:\t\t%s s\n',single);
fprintf('\taverage:\t%3.6f s\n',avg);



% method #3
fprintf(pad("norm",50,'right','.'))
t = tic;
Y = norm(X2-X);
single = sprintf('%3.6f',toc(t));

tv = nan(1,N);
for i = 1:N
    t = tic;
    Y = norm(X2-X);
    tv(i) = toc(t);   
end
avg = sum(tv)/N;

fprintf(' [ OK ]\n')
fprintf('\tsingle:\t\t%s s\n',single);
fprintf('\taverage:\t%3.6f s\n',avg);