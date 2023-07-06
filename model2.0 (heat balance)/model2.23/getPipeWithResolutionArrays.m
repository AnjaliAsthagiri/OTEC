function pipe = getPipeWithResolutionArrays(pipe, pipe_resolution)
    pipe.pipe_resolution = pipe_resolution;
    
    pipe.length_arr = linspace(0,pipe.length,pipe_resolution.length_resolution);
    pipe.dX = pipe.length_arr(2) - pipe.length_arr(1);
    
    initial_res = pipe_resolution.radius_initial_res * pipe.radius;
    exp_base = pipe_resolution.radius_exp_base;
    final_res_idx = calcLog(pipe.radius*(exp_base-1)/initial_res + 1, exp_base) - 1;
    final_res_idx = ceil(final_res_idx);
    radius_arr = arrayfun(@(x) initial_res*(exp_base^(x+1) - 1)/(exp_base-1), 0:final_res_idx);
    radius_arr = [0, radius_arr];
    if(radius_arr(end) > pipe.radius)
        radius_arr(end) = pipe.radius;
    end
    pipe.radius_arr = radius_arr;
end

function a = calcLog(x, base)
    a = log(x) / log(base);
end

% function pipe = getPipeWithResolutionArrays(pipe, resolution)
%     pipe.radius_arr = linspace(0,pipe.radius,resolution);
%     pipe.length_arr = linspace(0,pipe.length,resolution);
%     pipe.dX = pipe.length_arr(2) - pipe.length_arr(1);
%     pipe.resolution = resolution;
% end

% function pipe = getPipeWithResolutionArrays(pipe, cold_water)
%     boundary_step_size = 0.001; % change this later 
%     boundary_thickness = pipe.length/cold_water.velocity; %change this to add in coefficients
%     exp_base = 2; % change this
%     % do it until center + leftover 
%     total_exp_section = 0;
%     k = 0;
%     exp_growth_arr = [];
%     while (total_exp_section < (pipe.radius - boundary_thickness))
%         exp_growth_arr(k+1) = (exp_base^k)*boundary_step_size; %CHANGE THIS to iMRPVOE EFFICIENCY 
%         total_exp_section = total_exp_section + exp_growth_arr(k+1);
%         k = k + 1;
%     end
%     leftover_section = pipe.radius - boundary_thickness - total_exp_section;
%     if (leftover_section > 0)
%         pipe.radius_arr = [linspace(0,boundary_thickness, boundary_thickness/boundary_step_size), boundary_thickness+exp_growth_arr, boundary_thickness+exp_growth_arr(end)+leftover_section];
%     else
%         pipe.radius_arr = [linspace(0,boundary_thickness, boundary_thickness/boundary_step_size), boundary_thickness+exp_growth_arr];
%     end
%     pipe.length_arr = linspace(0,pipe.length,101);
%     pipe.dR = pipe.radius_arr(2) - pipe.radius_arr(1);
%     pipe.dX = pipe.length_arr(2) - pipe.length_arr(1);
% end