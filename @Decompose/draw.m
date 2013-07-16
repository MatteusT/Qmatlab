function draw(obj,piOnly,figNum)
%%
if (nargin < 2)
   figNum = 1;
end
figNum = figNum * 2 - 1;

% draw levels
xp = {[0    0.5];
   [2.25 2.75];
   [4.5 5]};
ft = {obj.frags{1}, obj.full, obj.frags{2}};
for ifrag = 1:3
    ft{ifrag}.drawEnergyLevels(figNum, xp{ifrag}, piOnly);
end

% draw overlap lines
dx = 0.0;
xc = {[xp{1}(2)+dx xp{2}(1)-dx] [xp{3}(1)-dx xp{2}(2)+dx]};
threshold = .25;
for ifrag = 1:2
    xs = xc{ifrag};
    obj.drawOverlap(figNum, ifrag, piOnly, xs, threshold);
end

obj.full.drawES(figNum, abs(xp{2}(1)-xp{2}(2)), xp{2}(1));


%%
figure(figNum+1);
% draw structures and orb magnitudes
scale = [1 1];
sx = 1.1;
xoffset = [-.75 .75] * sx;
sy = 1.1;
yoffset = [-1.5 -.5 .5 1.5] * sy;

objs = {obj.full, obj.frags{1}, obj.frags{2}};
for i = 1:length(objs)
    objs{i}.reorient();
end

bb = obj.full.boundingBox();
homo = ceil(obj.full.Nelectrons/2);
for i = -1:2
    center(1) = -bb.minx - (bb.width/2);
    center(2) = -bb.miny - (bb.height/2) + bb.height * (yoffset(i+2));
    if obj.full.rcart(1,obj.links(1)) > obj.full.rcart(1,obj.links(2))
        s = [-1 * scale(1), scale(2)];
    else
        s = scale;
    end
    obj.full.drawStructureOrb(homo+i, center, s);
    obj.drawPercents(figNum+1, homo+i, [0, center(2)], (bb.width/2));
end

values = {'left', obj.frags{1}; 'right', obj.frags{2}};
for j = 1:size(values,1)
    homo = ceil(values{j,2}.Nelectrons/2);
    tbb = values{j,2}.boundingBox();
    for k = 0:1
        center(1) = -tbb.minx - (tbb.width/2) + (bb.width) * xoffset(j) + sign(xoffset(j))*tbb.width/2;
        center(2) = -tbb.miny - (tbb.height/2) + tbb.height * (yoffset(k+2));
        values{j,2}.drawStructureOrb(homo+k, center, scale);
    end
end

end
