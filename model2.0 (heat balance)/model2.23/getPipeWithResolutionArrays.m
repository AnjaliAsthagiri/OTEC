function pipe = getPipeWithResolutionArrays(pipe, resolution)
    pipe.radius_arr = linspace(0,pipe.radius,resolution);
    pipe.length_arr = linspace(0,pipe.length,resolution);
    pipe.dX = pipe.length_arr(2) - pipe.length_arr(1);
    pipe.resolution = resolution;
end

% function pipe = getPipeWithResolutionArrays(pipe)
%     boundary_step_size = 0.00005; % change this later 
%     boundary_thickness = pipe.length/cold_water.velocity; %change this to add in coefficients
%     exp_base = 2; % change this
%     % do it until center + leftover 
%     total_exp_section = 0;
%     k = 0;
%     while (total_exp_section < (pipe.radius - boundary_thickness))
%         exp_growth_arr(k) = (exp_base^k)*boundary_step_size; %CHANGE THIS to iMRPVOE EFFICIENCY 
%         total_exp_section = total_exp_section + exp_growth_arr(k);
%         k = k + 1;
%     end
%     leftover_section = pipe.radius - boundary_thickness - total_exp_section;
%     pipe.radius_arr = [linspace(0,boundary_thickness, boundary_thickness/boundary_step_size), exp_growth_arr, leftover_section] 
%     pipe.length_arr = linspace(0,pipe.length,101);
%     pipe.dR = pipe.radius_arr(2) - pipe.radius_arr(1);
%     pipe.dX = pipe.length_arr(2) - pipe.length_arr(1);
% end