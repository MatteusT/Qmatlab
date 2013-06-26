function tempDir = writeTPL(obj,jobname,atoms,keywords,rLink)
    if isempty(atoms)
        atoms = 1:length(obj.Z);
    end
    newline = char(10);
    syms{1} = 'H'; syms{6} = 'C'; syms{7} = 'N'; syms{8} = 'O';
    syms{15} = 'P'; syms{16} = 'S';
    tpl_file = [jobname,'.tpl'];
    tempDir = [tempname('C:\G09W\Scratch'), '\'];
    mkdir(tempDir);
    fid1 = fopen([tempDir,tpl_file],'w');

    fwrite(fid1,['%chk=temp.chk',newline]);
    fwrite(fid1,['# ',keywords,' NoSymmetry iop(3/33=4) pop=regular',newline]);
    fwrite(fid1,newline);
    fwrite(fid1,jobname);
    fwrite(fid1,newline);
    fwrite(fid1,newline);
    fwrite(fid1,sprintf('%d %d', obj.charge, obj.multiplicity));
    fwrite(fid1,newline);
    for iatom = atoms(:)'
       fwrite(fid1,[' ',syms{obj.Z(iatom)},' ']);
       for ic = 1:3
          fwrite(fid1,[num2str(obj.rcart(ic,iatom)),' ']);
       end
       fwrite(fid1,newline);
    end
    if (nargin > 4)
       fwrite(fid1,[' H ',num2str(rLink(:)'),newline]);
    end
    fwrite(fid1,newline);

    fclose(fid1);
end

