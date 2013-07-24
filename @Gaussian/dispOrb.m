function dispOrb(obj, orb)
    gausspath = 'C:\G09W\';
    orb = ceil(orb);
    
    fch_file = [obj.dataPath, obj.filename, '.fch'];
    if ~exist(fch_file)
        fch_file = [obj.dataPath, obj.filename, '.fchk'];
    end
    cube_file = [obj.dataPath, obj.filename, '-', num2str(orb), '.cube '];
    if ~exist(cube_file)
        command = [gausspath, 'cubegen.exe 0 MO=', num2str(orb), ' ', fch_file, ' ', cube_file, '0 h'];
        disp(command);
        system(command);
    end

    fid = fopen(cube_file, 'r');
    t1 = textscan(fid, '%s');
    fclose(fid);
    text = t1{1};

    loc = utils.findText(text, {'MO', 'coefficients'}, 0);
    nAtoms = abs(str2double(text{loc+2}));
    Xnum = abs(str2double(text{loc+6}));
    pitch = abs(str2double(text{loc+6+1}));
    Ynum = abs(str2double(text{loc+6+4}));
    Znum = abs(str2double(text{loc+6+4+4}));
    loc = loc + 6 + 4 + 4 + 4; % skip all prev stuff
    loc = loc + 5 * nAtoms; % skip atom locations
    loc = loc + 1; % skip random numbers

    % can not preallocate matrix
    for i = 1:(Xnum*Ynum*Znum)
        V(i) = str2double(text{loc+i});
    end
    clear text
    vr = reshape(V, [Znum, Ynum, Xnum]);
    clear V
    vp = flipdim(flipdim(permute(vr, [2,3,1]),1),2);
    clear vr
    t = size(vp)*pitch/2;
    d = {-t(2):pitch:t(2)-pitch,-t(1):pitch:t(1)-pitch,-t(3)*2:pitch:-pitch};
    isosurface(d{1},d{2},d{3}, vp, -0.02);
    isosurface(d{1},d{2},d{3}, vp, 0.02);
    lighting phong;
    view([0,0,1]);
    daspect([1,1,1]);

    obj.drawStructureOrb(orb,[mean(d{1}),mean(d{2})],[-2, -2]);
    set(gca,'xdir','reverse');
end

