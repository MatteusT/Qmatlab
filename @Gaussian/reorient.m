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

    bb = obj.boundingBox();
    minpoint = obj.rcart(:,find(obj.rcart(1,:)==bb.minx));
    temp = princomp(obj.rcart(1:2,:)');
    angle = atan2(temp(1,2), temp(1,1));
    R = [cos(angle),-sin(angle); sin(angle),cos(angle)];

    sub = repmat(minpoint(1:2,:), 1, size(obj.rcart(1:2,:), 2));

    rcartpos = R*(obj.rcart(1:2,:)-sub) + sub;
    obj.rcart(1:2,:) = rcartpos;
end

