function [tot_tri_area] = findCrossArea(distance, obj_tri, dimension)
%     INPUT ARGUMENTS
%     distance: the distance along the specified axis of the object, of which to
%     find the crosssection
%     obj_tri: the triangulation of the object (it should have at least two
%     parameters - ConnectivityList & Points)
%     dimension: the specified axis of the object, of which to find the crosssection perpendicular to it
% 
%     OUTPUT ARGUMENTS
%     tot_tri_area: the calculated crosssectional area
    
    if dimension == 'x'
        plane_pts = [distance, -1000000, -1000000; distance, -1000000, 1000000; distance, 1000000, 1000000; distance, 1000000, -1000000];
    elseif dimension == 'y'
        plane_pts = [-5, distance, -5; -5, distance, 5; 5, distance, 5; 5, distance, -5];
    elseif dimension == 'z'
        plane_pts = [-5, -5, distance; -5, 5, distance; 5, 5, distance; 5, -5, distance];
    end
    
    plane_cl = [1, 2, 3; 3, 4, 1];
    obj_struct = [];
    obj_struct.faces = obj_tri.ConnectivityList;
    obj_struct.vertices = obj_tri.Points;
    plane_struct = [];
    plane_struct.faces = plane_cl;
    plane_struct.vertices = plane_pts;
    [~, si] = SurfaceIntersection(obj_struct, plane_struct);

    int_tri = delaunay(si.vertices(:, 2), si.vertices(:, 3));
    int_tri_pts = [si.vertices(:, 1), si.vertices(:, 2), si.vertices(:, 3)];

    tot_tri_area = 0;
    
    %cross-sectional area = sum areas of triangles in the connectivity list of the intersection surface
    for x = 1:size(int_tri,1)
        ab = int_tri_pts(int_tri(x, 1), :) - int_tri_pts(int_tri(x, 2), :);
        bc = int_tri_pts(int_tri(x, 1), :) - int_tri_pts(int_tri(x, 3), :);
        c = cross(ab, bc);
        tri_area = sqrt(c(1,1)*c(1,1) + c(1,2)*c(1,2) + c(1,3)*c(1,3)); % WHY NOT MULT BY 0.5????
        tot_tri_area = tot_tri_area + tri_area;
    end
end