function drawPercents(obj, figNum, orb, center, xoffset)
    figure(figNum);
    hold on;
    
    ranges{1} = 1:obj.links(1);
    ranges{2} = obj.links(2):length(obj.full.Z);
    values = obj.full.decompose(ranges ,orb);

    text(center(1)-xoffset, center(2), sprintf('%.2f',values(1)), 'horizontalalignment', 'right');
    text(center(1)+xoffset, center(2), sprintf('%.2f',values(2)), 'horizontalalignment', 'left');
end