%clear classes
%

cd('C:\Users\Matteus\Research\Qmatlab\G09\');
g = gaussian;

g.method = 'mp2';
g.basisSet = '6-21G';
g.dataPath = 'C:\Users\Matteus\Research\Qmatlab\testdat\';
g.jobName = 'h2';

g.runGaussian()

cd('C:\Users\Matteus\Research\Qmatlab\');