function drawES(obj,figNum,width,xoffset)
    if (nargin < 2)
       figNum = 1;
    end
    figure(figNum); %should match figure number from draw.m
    m = obj.full;
    nlevels = length(m.Ees);
    spacing = width/nlevels;
    for i = 1:nlevels
        x = (i-.5)*spacing+xoffset;
        ncomp = length(m.Ecomp{i});
        t = 0;
        spacing2 = width / max([50 ncomp]); % keep clusters together
        for ic = 1:ncomp
            t1 = m.Ecomp{i}{ic};
            if (t1.amp.^2 > 0.0)     
                hold on;
                plot([x+t*spacing2 x+t*spacing2],[m.Eorb(t1.filled) m.Eorb(t1.empty)],'r-');
                t = t + 1;
            end
        end
    end
end



