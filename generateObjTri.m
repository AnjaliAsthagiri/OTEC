function [obj_tri, leg_height] = generateObjTri(shape, leg_height, topLScale, topWScale, bottomLScale, bottomWScale, midLScale, midWScale)
    if shape == "Rectangle" || shape == "Trapezoid" || shape == "Reverse Trapezoid"
        %1x1x1 rectangular prism
        pts = [0, -1/2, -1/2; 0, -1/2, 1/2; 0, 1/2, 1/2; 0, 1/2, -1/2; 1, -1/2, -1/2; 1, -1/2, 1/2; 1, 1/2, 1/2; 1, 1/2, -1/2];
        pts(1:2, 2:3) = pts(1:2, 2:3)*topLScale;
        pts(3:4, 2:3) = pts(3:4, 2:3)*topWScale;
        pts(5:6, 2:3) = pts(5:6, 2:3)*bottomLScale;
        pts(7:8, 2:3) = pts(7:8, 2:3)*bottomWScale;
    elseif shape == "Hourglass"
        %1x1x1 rectangular prism
        pts = [0, -1/2, -1/2; 0, -1/2, 1/2; 0, 1/2, 1/2; 0, 1/2, -1/2; 1/2, -1/2, -1/2; 1/2, -1/2, 1/2; 1/2, 1/2, 1/2; 1/2, 1/2, -1/2; 1, -1/2, -1/2; 1, -1/2, 1/2; 1, 1/2, 1/2; 1, 1/2, -1/2];
        pts(1:2, 2:3) = pts(1:2, 2:3)*topLScale;
        pts(3:4, 2:3) = pts(3:4, 2:3)*topWScale;
        pts(5:6, 2:3) = pts(5:6, 2:3)*midLScale;
        pts(7:8, 2:3) = pts(7:8, 2:3)*midWScale;
        pts(9:10, 2:3) = pts(9:10, 2:3)*bottomLScale;
        pts(11:12, 2:3) = pts(11:12, 2:3)*bottomWScale;
    end
    pts(:, 1) = pts(:, 1)*leg_height;
    
    obj_tri = delaunayTriangulation(pts(:,1),pts(:,2),pts(:,3));
end


