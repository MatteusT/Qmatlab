qmatlab = 'C:\Users\ccollins\Documents\GitHub\Qmatlab\';
cd(fullfile(qmatlab, 'G09'));
path = 'C:\Users\ccollins\Desktop\start\ordered\';

mols = {'1A', '1B', '1C', '2A', '2B', '2C'};

for i = 1:length(mols)
    disp(mols{i});
    g1 = gaussian;
    g1.dataPath = path;
    g1.filename = mols{i}(1);
    g1.parseg09();

    g2 = gaussian;
    g2.dataPath = path;
    g2.filename = mols{i};
    g2.parseg09();

    g3 = gaussian;
    g3.dataPath = path;
    g3.filename = mols{i}(2);
    g3.parseg09();

    disp(all(g1.Z(1:end-1)==g2.Z(1:length(g1.Z)-1)));
    disp(all(g2.Z(length(g1.Z):end)==g3.Z(1:end-1)));
end

cd(qmatlab);