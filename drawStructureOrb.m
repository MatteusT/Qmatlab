function drawStructureOrb(m, orbital, offset, scale)
    maxx = max(m.rcart(1,:));
    maxy = max(m.rcart(2,:));
    minx = min(m.rcart(1,:));
    miny = min(m.rcart(2,:));
    aspect = (maxx - minx)/(maxy - miny);
    normed = norm([maxx maxy]);
    posx = ((m.rcart(1,:)-minx)/maxx)-1;
    posy = (((m.rcart(2,:)-miny)/maxy)-1)/aspect;
    e = m.Eorb(orbital);

    % draw structure
    for j=1:size(m.rcart,2)
        for k=j+1:size(m.rcart,2)
            if j == k 
                continue
            end
            xs = posx([j k]) * scale;
            ys = posy([j k]) * scale;

            dist = norm([xs(1)-xs(2), ys(1)-ys(2)]);
            if (dist - scale*3.3/normed) < 0
                hold on;
                plot(xs+offset, ys+e, 'Color', [0, 0, 0]);
                hold on;
            end
        end
    end

    % draw magnitide of coeffs
    for j=1:size(m.rcart,2)
        a1 = m.orb((m.atom == j) & (m.type == 1) & (m.subtype == 3) , orbital);
        if length(a1) == 0
            continue
        end
        if ~all(sign(a1)==sign(a1(1)))
            disp(a1);
            disp(j);
        end
        r = sign(sum(a1)) * norm(a1) * 10*scale;
        x = posx(j)*scale;
        y = posy(j)*scale;
        drawCircle(x+offset, y+e, r*scale);
        hold on;
    end
end

