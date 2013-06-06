%clear classes
%

qmatlab = pwd;
cd(fullfile(qmatlab, '\G09'));
params =  {                             ...
    {'METHOD', {'mp2', 'B3LYP'}, 1}, ...
    {'BASIS', {'6-21G', 'STO-3G', '6-31G'}, 1}, ...
};
c = controller(fullfile(qmatlab, 'testdat\'), 'h2', params);
c.runAll();

cd(qmatlab);