qmatlab = pwd;

mols = {    ...
    '1A', 1:13, 14:24, [13 14]; ...
    '1B', 1:13, 14:21, [13 14]; ...
    '1C', 1:13, 14:21, [13 14]; ...
    '2A', 1:15, 16:26, [15 16]; ...
    '2B', 1:15, 16:23, [15 16]; ...
    '2C', 1:15, 16:23, [15 16]; ...
};
objs = cell(size(mols,1), 1);
e = zeros(size(objs,1)*2,1);

dataPath = 'C:\Users\ccollins\Desktop\start\ordered\cart\';
for i=1:size(mols,1)
    disp(mols{i, 1});
    gstart = Gaussian(dataPath,mols{i,1},struct);
    gstart.run();

    fragList{1} = mols{i,2};
    fragList{2} = mols{i,3};
    links = mols{i,4};
    rlinks = [1.1 1.1];
    keywords = 'b3lyp/sto-3g';
    obj = Decompose(gstart,fragList,links,rlinks,keywords);
    obj.initialize();
    objs{i} = obj;

    homo = objs{i}.full.Nelectrons/2;
    e(i*2-1) = objs{i}.full.Eorb(homo+6);
    e(i*2) = objs{i}.full.Eorb(homo-5);
end

ymax = max(e);
ymin = min(e);

for i=1:size(objs,1)
    objs{i}.draw(1,i);
    figure(i * 2 - 1);
    axis([0 5 ymin ymax]);
end