function initialize(obj)

% Calculation on the full molecule
fullList = [obj.fragList{1}(:);obj.fragList{2}(:)];
keywords = ['td ', obj.keywords];
tempdir = writeTPL(obj,obj.fullIn.filename,fullList,keywords);
obj.full = Gaussian(tempdir,obj.fullIn.filename,struct);
obj.full.run();

% fragment calcs
%  vector pointing from link1 to link2
direction = obj.fullIn.rcart(:,obj.links(2)) - ...
   obj.fullIn.rcart(:,obj.links(1));
% hydrogen on frag1 is directed away from link 1 along direction
rLink{1} = obj.fullIn.rcart(:,obj.links(1)) + ...
   obj.rlinks(1) * direction/norm(direction);
% hydrogen on frag2 is directed away from link 2 along -direction
rLink{2} = obj.fullIn.rcart(:,obj.links(2)) - ...
   obj.rlinks(2) * direction/norm(direction);
for ifrag = 1:2
   name = [obj.fullIn.filename,'-',int2str(ifrag)];
   tempdir = writeTPL(obj,name,obj.fragList{ifrag},obj.keywords,rLink{ifrag});
   obj.frags{ifrag} =  Gaussian(tempdir,name,struct);
   obj.frags{ifrag}.run();
end

% map fragment AO basis to full AO basis
icount = 1;
for ifrag = 1:2
   ft = obj.frags{ifrag};
   obj.nonLink{ifrag} = find(ft.atom ~= ft.atom(end));
   lengthNonLink = length(obj.nonLink{ifrag});
   % assume same ordering of orbs in full as frag, without link
   obj.maps{ifrag} = icount:(icount + lengthNonLink - 1);
   icount = icount + lengthNonLink;
end

% calculate overlaps
for ifrag = 1:2
   % frag(ao,mo)' * S(ao,ao) * full(ao,mo)
   noLink = obj.nonLink{ifrag};
   ofrag = obj.frags{ifrag}.orb(noLink,:);
   Stemp = obj.full.overlap(obj.maps{ifrag},:);
   ofull = obj.full.orb(:,:);
   obj.overlap{ifrag} = ofrag' * Stemp * ofull;
end
end


function tempDir = writeTPL(obj,jobname,atoms,keywords,rLink)
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
fwrite(fid1,'0 1');
fwrite(fid1,newline);
for iatom = atoms(:)'
   fwrite(fid1,[' ',syms{obj.fullIn.Z(iatom)},' ']);
   for ic = 1:3
      fwrite(fid1,[num2str(obj.fullIn.rcart(ic,iatom)),' ']);
   end
   fwrite(fid1,newline);
end
if (nargin > 4)
   fwrite(fid1,[' H ',num2str(rLink(:)'),newline]);
end
fwrite(fid1,newline);

fclose(fid1);
end

