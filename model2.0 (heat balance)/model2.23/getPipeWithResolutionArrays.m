function pipe = getPipeWithResolutionArrays(pipe)
    boundary_step_size = 0.00005 % change this later 
    boundary_thickness = pipe.length/cold_water.velocity;
    pipe.radius_arr = [linspace(0,boundary_thickness, boundary_thickness/boundary_step_size); ] 
    pipe.length_arr = linspace(0,pipe.length,101);
    
    pipe.dR = pipe.radius_arr(2) - pipe.radius_arr(1);
    pipe.dX = pipe.length_arr(2) - pipe.length_arr(1);
end