%clear classes
% This is a test of running just one molecule

qmatlab = pwd;

params =  {                             ...
    {'METHOD', {'mp2'}, 1}, ...
    {'BASIS', {'6-21G'}, 1}, ...
};
c = controller(fullfile(qmatlab, 'testdat\'), 'h2', params);
c.runAll();

cd(qmatlab);
%% Ampac Test
Am = Ampac;
Am.dataPath = 'C:\Users\Matteus\Qmatlab\testdat\';
Am.jobName = 'ch4';
Am.method = 'sam1';
Am.par = [1.000 1.200];

Am.runAmpac()

%% INDO Test
In = Indo;
dataPath = 'C:\Users\Matteus\Qmatlab\testdat\';
jobName = 'ch4_sam1';
parameterFile = 'C:\Users\Matteus\Qmatlab\testdat\parameters';
config = In.defaultConfig();
Indo(config,dataPath,jobName,parameterFile);
