%clear classes
%
qmatlab = 'C:\Users\ccollins\Documents\GitHub\Qmatlab\';
cd(fullfile(qmatlab, 'G09'));
g = gaussian;

g.method = 'mp2';
g.basisSet = '6-21G';
g.dataPath = fullfile(qmatlab, 'testdat\');
g.jobName = 'h2';

g.runGaussian()

cd(qmatlab);