function drawStructureOrb(m, orbital, offset, scale)
    posx = m.rcart(1,:)+offset(1);
    posy = m.rcart(2,:)+offset(2);

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
        if m.Z(j) > 6
            hold on;
            if m.Z(j) == 16
                color = 'y';
            else
                color = [1 .5 0];
            end
            rectangle('Position',[posx(j)-.05,posy(j)-.05,.1,.1],'Curvature',[1,1],'FaceColor',color);
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

