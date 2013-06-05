%clear classes
%% Gaussian Test

cd('C:\Users\Matteus\Qmatlab\G09\');
g = gaussian;

g.method = 'mp2';
g.basisSet = '6-21G';
g.dataPath = 'C:\Users\Matteus\Qmatlab\testdat\';
g.jobName = 'h2';

g.runGaussian()

cd('C:\Users\Matteus\Qmatlab');
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

cd('C:\Users\Matteus\Qmatlab\Ampac\');


