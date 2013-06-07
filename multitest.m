%clear classes
% This is an example of running tests with multiple parameters
% In this example, various basis sets are used to plot the energy of
% hydrogen based on the bond length.

qmatlab = pwd;
cd(fullfile(qmatlab, '\G09'));

range = [.5:.1:2.5];
params =  {                             ...
    {'METHOD', {'mp2'}, 1}, ...
    {'BASIS', {'STO-3G', '6-21G', '6-31G'}, 1}, ...
    {'BONDLEN', range, 1}, ...
};
c = controller(fullfile(qmatlab, 'testdat\'), 'h2-2', params);
c.runAll();

% Loop over all the ouputs and the energy
e = zeros(length(range),3);
for i=1:length(c.outputs)
    e(i)=c.outputs{i}.Ehf;
end

plot(range,e);

cd(qmatlab);