function drawStructureOrb(m, bounds, orbital, offset, scale)
    posx = (m.rcart(1,:)-bounds.minx)-(bounds.width/2)+offset(1);
    posy = (m.rcart(2,:)-bounds.miny)-(bounds.height/2)+offset(2);

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
                plot(xs, ys, 'Color', [0, 0, 0]);
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
        drawCircle(x, y, r*scale);
        hold on;
    end
end

