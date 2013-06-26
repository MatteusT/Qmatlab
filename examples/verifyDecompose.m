%% start by doing an optimization of butadiene
clear classes
cd('..');
qmatlab = pwd;

mat1 = [qmatlab, '\testdat\gstart.mat'];
if exist(mat1, 'file') ~= 2
    gstart = Gaussian([qmatlab, '\testdat\'],'butadiene',struct);
    gstart.run();
    save(mat1);
else
    load(mat1);
end
%%

mat2 = [qmatlab, '\testdat\gtemp2.mat'];
if exist(mat2, 'file') ~= 2
    fragList{1} = 1:5;
    fragList{2} = 6:10;
    links = [4 6];
    rlinks = [1.1 1.1];
    keywords = 'b3lyp/sto-3g';
    obj = Decompose(gstart,fragList,links,rlinks,keywords);
    obj.initialize();
    save(mat2);
else
    load(mat2);
end

disp(['basis size: full ',num2str(length(obj.full.atom)), ...
   ' frag1 ',num2str(length(obj.frags{1}.atom)), ...
   ' frag2 ',num2str(length(obj.frags{1}.atom))]);
disp(['frag1 ',num2str(obj.maps{1}(:)')]);
disp(['frag2 ',num2str(obj.maps{2}(:)')]);

s1 = obj.overlap{1};
s2 = obj.overlap{2};
max(max(abs(s1.^2 -s2.^2)))

obj.draw(0,10);
