function srcToPath()

% this function adds all methods in src/ dir to path

% note: for use on the cluster, src/ dir is: /hpc/stats/users/wdn2101/nodetop/src/

srcDirStrings = {'''src''','''/hpc/stats/users/wdn2101/nodetop/src'''};
for i=1:length(srcDirStrings)
    evalString = ['addpath(genpath(', srcDirStrings{i}, '))'];
    evalin('caller', evalString);
    disp(evalString);
    disp([srcDirStrings{i}, ' dir added to path.']);
end
