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