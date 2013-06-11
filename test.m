%clear classes
% This is a test of running just one molecule

qmatlab = pwd;

params =  {                             ...
    {'METHOD', {'mp2'}, 1}, ...
    {'BASIS', {'6-21G'}, 1}, ...
};
c = controller(fullfile(qmatlab, 'testdat\'), 'h2', params, @Gaussian);
c.runAll();

cd(qmatlab);
%% Ampac Test
qmatlab = pwd;

params =  {                             ...
    {'METHOD', {'sam1'}, 1}, ...
    {'PAR1', 1.0000, 1}, ...
    {'PAR2', 1.2000, 1}, ...
};
c = controller(fullfile(qmatlab, 'testdat\'), 'ch4', params, @Ampac);
c.runAll()

%% INDO Test
In = Indo;
dataPath = 'C:\Users\Matteus\Qmatlab\testdat\';
jobName = 'ch4_sam1';
parameterFile = 'C:\Users\Matteus\Qmatlab\testdat\parameters';
config = In.defaultConfig();
Indo(config,dataPath,jobName,parameterFile);
