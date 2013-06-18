function drawStructureOrb(m, orbital, offset, scale)
    minx = min(m.rcart(1,:));
    miny = min(m.rcart(2,:));
    maxx = max(m.rcart(1,:)-minx);
    maxy = max(m.rcart(2,:)-miny);
    aspect = (maxx - minx)/(maxy - miny);
    posx = ((m.rcart(1,:)-minx)/maxx)-1;
    posy = (((m.rcart(2,:)-miny)/maxy)-1)/aspect;
    e = m.Eorb(orbital);

    % draw structure
    for j=1:size(m.rcart,2)
        for k=j+1:size(m.rcart,2)
            if any(m.Z([j k]) == 1)
                limit = 1.15;
            else
                if any(m.Z([j k]) > 6)
                    limit = 2;
                else
                    limit = 1.7;
                end
            end
            dx = m.rcart(1,j) - m.rcart(1,k);
            dy = m.rcart(2,j) - m.rcart(2,k);
            dist = norm([dx, dy]);
            if (dist - limit) < 0
                hold on;
                xs = posx([j k]) * scale;
                ys = posy([j k]) * scale;
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
        r = sign(sum(a1)) * norm(a1) * scale * 2;
        x = posx(j) * scale;
        y = posy(j) * scale;
        drawCircle(x+offset, y+e, r*scale);
        hold on;
    end
end

