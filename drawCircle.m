function drawCircle(x, y, r)
    color = [0,0,1];
    if r < 0
        r = abs(r);
        color = [1,0,0];
    end
    ang=0:0.01:2*pi;
    xp=r*cos(ang);
    yp=r*sin(ang);
    plot(x+xp,y+yp, 'Color', color);
end

