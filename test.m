%clear classes
%
qmatlab = pwd;
cd(fullfile(qmatlab, '\G09'));
g = gaussian('h2', fullfile(qmatlab, 'testdat\'), 'mp2', '6-21G');
g.runGaussian()

cd(qmatlab);