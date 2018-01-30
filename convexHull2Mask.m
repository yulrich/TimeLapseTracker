
function [M]=convexHull2Mask(bwpic)

[ABDx,ABDy]=find(bwpic);
% unless all points are collinear, compute convex hull and create corresponding mask
if size(unique(ABDx),1)>1 && size(unique(ABDy),1)>1
    try
        ABDHull=convhull(ABDy,ABDx);
        M=poly2mask(ABDy(ABDHull),ABDx(ABDHull),size(bwpic,1),size(bwpic,2));
    catch
        M=bwpic;
    end
    % otherwise, bwpic is the mask
else
    M=bwpic;
end

