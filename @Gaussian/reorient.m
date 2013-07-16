function reorient(obj)
    bb = obj.boundingBox();
    vals = [bb.width, bb.height, bb.depth];
    minv = min(vals);
    maxv = max(vals);
    rcart = [];
    rcart(1,:) = obj.rcart(find(vals == maxv),:);
    rcart(2,:) = obj.rcart(find(vals < maxv & vals > minv),:);
    rcart(3,:) = obj.rcart(find(vals == minv),:);
    obj.rcart = rcart;
    
    for j = 1:2
        bb = obj.boundingBox();
        minpoint = obj.rcart(:,find(obj.rcart(1,:)==bb.minx));
        maxpoint = obj.rcart(:,find(obj.rcart(1,:)==bb.maxx));
        angle = -atan2(maxpoint(2)-minpoint(2),maxpoint(1)-minpoint(1));
        R = [cos(angle),-sin(angle); sin(angle),cos(angle)];

        sub = ones(size(obj.rcart(1:2,:)));
        sub(1,:) = sub(1,:)*minpoint(1);
        sub(2,:) = sub(2,:)*minpoint(2);
        rcart = R*(obj.rcart(1:2,:)-sub) + sub;
        obj.rcart(1:2,:) = rcart;
    end
end

