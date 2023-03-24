hot_temp = 300.15;
cold_temp = 279.15;
global s_heat_capacity_water
s_heat_capacity_water = 4184; % j/(kg*oC)
global therm_conduct_water
therm_conduct_water = 0.598; % W/m·K at 20 °C

pipe_length = 1;
global pipe_radius
pipe_radius = 0.5;
TE_thickness = 0.1;
TE_width = 0.1;
insul_width = 0.001;
global velocity 
velocity = 2;

model = createpde;
material_rect_x = [0, 0];
material_rect_y = [0, pipe_radius+TE_thickness];
for n = 1 : 1 : floor(pipe_length/TE_width)
    if (TE_width*n + insul_width < pipe_length)
        material_rect_x = [material_rect_x, TE_width*n, TE_width*n, TE_width*n + insul_width, TE_width*n + insul_width];
        material_rect_y = [material_rect_y, pipe_radius+TE_thickness, pipe_radius, pipe_radius, pipe_radius+TE_thickness];
    end
end
material_rect_x = [material_rect_x, pipe_length, pipe_length];
material_rect_y = [material_rect_y, pipe_radius+TE_thickness, 0];
material_rect = [3,4,material_rect_x,material_rect_y]';
pgon = polyshape(material_rect_x, material_rect_y);
tr = triangulation(pgon);
tnodes = tr.Points';
telements = tr.ConnectivityList';
gm = geometryFromMesh(model,tnodes,telements);
pdegplot(model,'EdgeLabels','on','FaceLabels','on')
axis equal

leftEdge = nearestEdge(gm,[0 pipe_radius/2]);
bottomEdge = nearestEdge(gm,[pipe_length/2 0]);
topEdges = zeros(1, n-1);
for n2 = 0 : 1 : n-1
    topEdges(n2+1) = nearestEdge(gm,[TE_width*n2+TE_width/2 pipe_radius+TE_thickness]);
end
applyBoundaryCondition(model,'dirichlet','Edge',topEdges,'h',1,'r',hot_temp);
applyBoundaryCondition(model,'neumann','Edge',bottomEdge,'g',0,'q',0);
applyBoundaryCondition(model,'dirichlet','Edge',leftEdge,'h',1,'r',cold_temp);

specifyCoefficients(model,'m',0,'d',0,'c',@cfun,'a',0,'f',@ffun);

generateMesh(model);
results = solvepde(model);

figure
pdeplot(model,'XYData',results.NodalSolution)

function [f] = ffun(location, state)
    global velocity
    global s_heat_capacity_water
    global pipe_radius
    if (location.y <= pipe_radius)
        f = -velocity.*location.y*s_heat_capacity_water.*state.ux;
    else
        f = 0.*location.y;
    end
end

function [c] = cfun(location, state)
    global therm_conduct_water
    global pipe_radius
    if (location.y <= pipe_radius)
        c = therm_conduct_water.*location.y;
    else
        c = location.y;
    end
end
