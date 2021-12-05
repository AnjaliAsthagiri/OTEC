function [num_modules, mod_power, mod_voltage, power_per_volume] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, res)
    mod_voltage = temp_diff * mod_seebeck;
    dx = leg_height/res;
    mod_elec_resistance = 0;
    for x = 0 : dx : leg_height-dx
        area = findCrossArea(x, obj_tri, 'x');
        mod_elec_resistance = mod_elec_resistance + mod_elec_resistivity*dx/area;
    end
    mod_power = mod_voltage^2/(4*mod_elec_resistance);
    num_modules = tot_power/mod_power;
    
    tot_volume = num_modules * volume(tm.Mesh);
    power_per_volume = tot_power/tot_volume;
end

%%
% 
% mod_resistance = 0;
% 
% %% TRAPEZOID
% if leg_shape == "Trapezoid"
%     for x = 0 : leg_height/res : leg_height-leg_height/res
%         area = calc_area_trapezoid(leg_width/2, leg_width, leg_height, x);
%         mod_resistance = mod_resistance + (mod_resistivity*leg_height/res)/area;
%     end
% end
% 
% %% RECTANGLE
% if leg_shape == "Rectangle"
%     for x = 0 : leg_height/res : leg_height-leg_height/res
%         area = leg_width^2;
%         mod_resistance = mod_resistance + (mod_resistivity*leg_height/res)/area;
%     end
% end
% 
% %% HOURGLASS
% if leg_shape == "Hourglass"
%     for x = 0 : leg_height/res : leg_height-leg_height/res
%         area = calc_area_trapezoid(leg_width/2, leg_width, leg_height/2, abs(x-(leg_height/2)));
%         mod_resistance = mod_resistance + (mod_resistivity*leg_height/res)/area;
%     end
% end
% 
% %% INVERSE HOURGLASS
% if leg_shape == "Inverse Hourglass"
%     for x = 0 : leg_height/res : leg_height-leg_height/res
%         area = calc_area_trapezoid(leg_width/2, leg_width, leg_height/2, leg_height/2 - abs(x-(leg_height/2)));
%         mod_resistance = mod_resistance + (mod_resistivity*leg_height/res)/area;
%     end
% end
% 
% %% CALCULATIONS
% p_voltage = (real_temp_hot - real_temp_cold) * p_seebeck;
% n_voltage = (real_temp_hot - real_temp_cold) * n_seebeck;
% mod_voltage = p_voltage - n_voltage;
% mod_power = mod_voltage^2/(4*mod_resistance);
% num_modules = tot_power/mod_power;
% tot_volume = leg_height*leg_width*leg_width*num_modules*2;
% 
% %% FUNCTIONS
% 
% function [area] = calc_area_trapezoid (length_small, length_large, total_height, x) % x = dist from small end
%     area = (2*(length_large/2 - (length_large/2 - length_small/2)*(total_height-x)/total_height))^2;
% end
% 
