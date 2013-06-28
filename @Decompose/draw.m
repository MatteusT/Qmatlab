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
   ol = obj.overlap{ifrag}.^2;
   Efrag = obj.frags{ifrag}.Eorb;
   Efull = obj.full.Eorb;
   for j = 1:length(Efrag)
      for k = 1:length(Efull)
         if (~piOnly || (obj.full.piCharacter(k)>0.1))
            if ol(j,k)>threshold
               e1 = Efrag(j);
               e2 = Efull(k);
               if (k <= obj.full.Nelectrons/2)
                  format = 'b';
               else
                  format = 'g';
               end
               plot(xc{ifrag},[e1 e2],[format,':']);
            end
         end
      end
   end
end

obj.drawES(figNum, abs(xp{2}(1)-xp{2}(2)), xp{2}(1));


%%
figure(figNum+1);
% draw structures and orb magnitudes
scale = 1;
sx = 1.1;
xoffset = [-.75 .75] * sx;
sy = 1.1;
yoffset = [-1.5 -.5 .5 1.5] * sy;


bb = boundingBox(obj.full.rcart);
homo = obj.full.Nelectrons/2;
for i = -1:2
    center(1) = -bb.minx - (bb.width/2);
    center(2) = -bb.miny - (bb.height/2) + bb.height * (yoffset(i+2));
    obj.full.drawStructureOrb(homo+i, center, scale);
    
    S = obj.full.overlap;
    ranges{1} = find(obj.full.atom <= obj.links(1));
    ranges{2} = find(obj.full.atom >= obj.links(2));
    popFrags = zeros(2,2);
    for j=1:2
        for k = 1:2
            popFrags(j,k) = obj.full.orb(ranges{j},homo+i)' * S(ranges{j},ranges{k}) * obj.full.orb(ranges{k},homo+i);
        end
    end
    left = popFrags(1,1) + 0.5 * popFrags(1,2) + 0.5 * popFrags(2,1);
    right = popFrags(2,2) + 0.5 * popFrags(1,2) + 0.5 * popFrags(1,2);
    text(center(1)-(bb.width/2), center(2), sprintf('%.2f',left), 'horizontalalignment', 'right');
    text(center(1)+(bb.width/2), center(2), sprintf('%.2f',right), 'horizontalalignment', 'left');
end

values = {'left', obj.frags{1}; 'right', obj.frags{2}};
for j = 1:size(values,1)
    homo = values{j,2}.Nelectrons/2;
    tbb = boundingBox(values{j,2}.rcart);
    for k = 0:1
        center(1) = -tbb.minx - (tbb.width/2) + (bb.width) * xoffset(j) + sign(xoffset(j))*tbb.width/2;
        center(2) = -tbb.miny - (tbb.height/2) + tbb.height * (yoffset(k+2));
        values{j,2}.drawStructureOrb(homo+k, center, scale);
    end
end

end
%%

function res = boundingBox(positions)
    res.minx = min(positions(1,:));
    res.miny = min(positions(2,:));
    res.width = max(positions(1,:))-res.minx;
    res.height = max(positions(2,:))-res.miny;
end