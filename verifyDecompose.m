%% start by doing an optimization of butadiene
clear classes
qmatlab = pwd;

if (1)
    gstart = Gaussian([qmatlab, '\testdat\'],'butadiene',{});
    gstart.run();
    save([qmatlab, '\testdat\gstart.mat']);
else
    load([qmatlab, '\testdat\gstart.mat']);
end
%%

if (1)
    fragList{1} = 1:5;
    fragList{2} = 6:10;
    links = [4 6];
    rlinks = [1.1 1.1];
    keywords = 'b3lyp/sto-3g';
    obj = Decompose(gstart,fragList,links,rlinks,keywords);
    obj.initialize();
    save([qmatlab, '\testdat\gtemp2.mat']);
else
    load([qmatlab, '\testdat\gtemp2.mat']);
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
