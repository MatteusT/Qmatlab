function initialize(obj)

% Calculation on the full molecule
fullList = [obj.fragList{1}(:);obj.fragList{2}(:)];
keywords = ['td ', obj.keywords];
name = obj.fullIn.filename;
tempdir = obj.fullIn.writeTPL(name,fullList,keywords);
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
   tempdir = obj.full.writeTPL(name,obj.fragList{ifrag},obj.keywords,rLink{ifrag});
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