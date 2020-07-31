% GETGENLIST Returns the logical indices of all generators, the slack false

% Copyright (C) 2020 Timon Viola
function generatorList = getGenList(mpc)
   slackIdx = mpc.bus(:,2) == 3; % bus type == ref
   slackBus = mpc.bus(slackIdx,1); % slack bus number
   generatorList = mpc.gen(:,1) ~= slackBus; % L 
end