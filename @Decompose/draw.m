function draw(obj,piOnly,figNum)
if (nargin < 2)
   figNum = 1;
end

xp = {[0    0.5];
   [2.25 2.75];
   [4.5 5]};
% draw levels
ft = {obj.frags{1}, obj.full, obj.frags{2}};
nbasis = [size(obj.frags{1}.orb,1), size(obj.full.orb,1), ...
   size(obj.frags{2}.orb,1)];

figure(figNum);
clf;
hold on;
for ifrag = 1:3
   for iorb = 1:nbasis(ifrag)
      e = ft{ifrag}.Eorb(iorb);
      if (iorb <= ft{ifrag}.Nelectrons/2)
         format = 'b'; % filled orbs are blue
      else
         format = 'g'; % empty orbs are green
      end
      if (piOnly && (piCharacter(ft{ifrag},iorb) < 0.1))
         format = 'y'; % non-pi will be yellow
      end
      plot(xp{ifrag}, [e e], format);
   end
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
         if (~piOnly || (piCharacter(obj.full,k)>0.1))
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

scale = .2;
xoffset = [-.75 .5 -.5 .75];

% draw structures and orb magnitudes
center = mean(xp{2});
homo = obj.full.Nelectrons/2;
for j = -1:2
    offset = center+xoffset(j+2);
    drawStructureOrb(obj.full, homo+j, offset, scale);
end

values = {'left', obj.frags{1}, 1; 'right', obj.frags{2}, -1};
for j = 1:size(values,1)
    homo = values{j,2}.Nelectrons/2;
    center = mean(xp{2-values{j,3}});
    for k = 0:1
        offset = center+.5*values{j,3};
        drawStructureOrb(values{j,2}, homo+k, offset, scale);
    end
end

end

function res = piCharacter(m, iorb)
  % m is a guassian calc for a molecule lying in x,y plane
  a1 = m.orb((m.type == 1) & (m.subtype == 3) , iorb);
  res = sum(a1.^2);
end
