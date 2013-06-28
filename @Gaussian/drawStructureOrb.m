function drawStructureOrb(obj, orbital, offset, scale)
    posx = obj.rcart(1,:)+offset(1);
    posy = obj.rcart(2,:)+offset(2);

    % draw structure
    for j=1:size(obj.rcart,2)
        for k=j+1:size(obj.rcart,2)
            if any(obj.Z([j k]) == 1)
                limit = 1.15;
            else
                if any(obj.Z([j k]) > 6)
                    limit = 2;
                else
                    limit = 1.7;
                end
            end
            dx = obj.rcart(1,j) - obj.rcart(1,k);
            dy = obj.rcart(2,j) - obj.rcart(2,k);
            dist = norm([dx, dy]);
            if (dist - limit) < 0
                hold on;
                xs = posx([j k]) * scale(1);
                ys = posy([j k]) * scale(2);
                plot(xs, ys, 'Color', [0, 0, 0]);
                hold on;
            end
        end
        if obj.Z(j) > 6
            switch obj.Z(j)
               case 8
                   color = 'r';
                case 15
                  color = [1 .5 0];
                case 16
                  color = 'y';
            end
            hold on;
            t = abs(scale)*.1;
            px = posx(j)*scale(1)-t(1);
            py = posy(j)*scale(2)-t(2);
            rectangle('Position',[px,py,t(1)*2,t(2)*2],'Curvature',[1,1],'FaceColor',color);
        end
    end

    % draw magnitide of coeffs
    for j=1:size(obj.rcart,2)
        a1 = obj.orb((obj.atom == j) & (obj.type == 1) & (obj.subtype == 3) , orbital);
        if length(a1) == 0
            continue
        end
        r = sign(sum(a1)) * sqrt(norm(a1) * abs(scale(1)) * 2);
        x = posx(j) * scale(1);
        y = posy(j) * scale(2);
        utils.drawCircle(x, y, r*scale(1));
        hold on;
    end
end

