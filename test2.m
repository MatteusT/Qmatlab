qmatlab = 'C:\Users\ccollins\Documents\GitHub\Qmatlab\';
cd(fullfile(qmatlab, 'G09'));
path = 'C:\Users\ccollins\Desktop\start\ordered\';

g1 = gaussian;
g1.dataPath = path;
g1.filename = '1';
g1.parseg09();

g2 = gaussian;
g2.dataPath = path;
g2.filename = '1A';
g2.parseg09();

g3 = gaussian;
g3.dataPath = path;
g3.filename = 'B';
g3.parseg09();

cd(qmatlab);