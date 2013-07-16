function res = boundingBox(obj)
    res.minx = min(obj.rcart(1,:));
    res.miny = min(obj.rcart(2,:));
    res.minz = min(obj.rcart(3,:));
    
    res.maxx = max(obj.rcart(1,:));
    res.maxy = max(obj.rcart(2,:));
    res.maxz = max(obj.rcart(3,:));
    
    res.width = res.maxx-res.minx;
    res.height = res.maxy-res.miny;
    res.depth = res.maxz - res.minz;
end

