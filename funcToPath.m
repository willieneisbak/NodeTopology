
function funcToPath()

% this function adds all methods in func/ folder to path
% for use on the cluster
% where func is:   /hpc/stats/users/wdn2101/nodetop/func/


funcDirString = '''/hpc/stats/users/wdn2101/nodetop/func''';
evalString = ['addpath(genpath(', funcDirString, '))'];
evalin('caller', evalString);
disp(evalString);
disp('''func/'' dir added to path.');