%clear classes
% This is a test of running just one molecule

qmatlab = pwd;
cd(fullfile(qmatlab, '\G09'));
params =  {                             ...
    {'METHOD', {'mp2'}, 1}, ...
    {'BASIS', {'6-21G'}, 1}, ...
};
c = controller(fullfile(qmatlab, 'testdat\'), 'h2', params);
c.runAll();

cd(qmatlab);
%% Ampac Test
cd('C:\Users\Matteus\Qmatlab\Ampac\');
Am = Ampac;
Am.dataPath = 'C:\Users\Matteus\Qmatlab\testdat\';
Am.jobName = 'ch4';
Am.method = 'sam1';
Am.par = [1.000 1.200];

Am.runAmpac()

cd('C:\Users\Matteus\Qmatlab\');

%%

cd('C:\Users\Matteus\Qmatlab\INDO\');

In = Indo;
dataPath = 'C:\Users\Matteus\Qmatlab\testdat\';
jobName = 'ch4_sam1';
parameterFile = 'C:\Users\Matteus\Qmatlab\testdat\parameters';
config = In.defaultConfig();
Indo(config,dataPath,jobName,parameterFile);

cd('C:\Users\Matteus\Qmatlab\');
