qmatlab = 'C:\Users\ccollins\Documents\GitHub\Qmatlab\';
cd([qmatlab, 'G09']);
path = 'C:\Users\ccollins\Desktop\start\ordered\';

mols = {'1A', '1B', '1C', '2A', '2B', '2C'};
frags = cell(6);

for i = 1:length(mols)
    disp(mols{i});
    f1 = gaussian;
    f1.dataPath = path;
    f1.filename = mols{i}(1);
    f1.parseg09();
    frags{i}{1} = f1;

    m = gaussian;
    m.dataPath = path;
    m.filename = mols{i};
    m.parseg09();
    frags{i}{2} = m;

    f2 = gaussian;
    f2.dataPath = path;
    f2.filename = mols{i}(2);
    f2.parseg09();
    frags{i}{3} = f2;

    disp([all(f1.Z(1:end-1)==m.Z(1:length(f1.Z)-1)), ...
          all(m.Z(length(f1.Z):end)==f2.Z(1:end-1))]);
end

cd(qmatlab);