num_modules = 100000000;
% finding heat flux
%heat flux equation is Q = (KAdeltaT)/l
points = [0, -leg_width/2, -leg_width/2; 0, -leg_width/2, leg_width/2; 0, leg_width/2, leg_width/2; 0, leg_width/2, -leg_width/2; leg_height, -leg_width/2, -leg_width/2; leg_height, -leg_width/2, leg_width/2; leg_height, leg_width/2, leg_width/2; leg_height, leg_width/2, -leg_width/2];
% points = [0, -leg_width/2, -leg_width/2; 0, -leg_width/2, leg_width/2; 0, leg_width/2, leg_width/2; 0, leg_width/2, -leg_width/2; leg_height, -leg_width/4, -leg_width/4; leg_height, -leg_width/4, leg_width/4; leg_height, leg_width/4, leg_width/4; leg_height, leg_width/4, -leg_width/4];
S = delaunayTriangulation(points(:,1),points(:,2),points(:,3));

heat_flux_leg = find_heat_flux_leg(S, results, leg_height, res, therm_conductivity);
% total heat flux, from hot to cold, in watts (J/s)
heat_flux_tot = heat_flux_leg * num_modules * 2;

%finding amount of water
water_cp = 4.184;  %J/g*C, specific heat of water
% this is the temperature change that we are allowing, in degrees celsius
delta_t_allowed_water = 1;
% this is the amount of water that gets heated to the degrees celsius allotted every second 
g_water_heated  = (heat_flux_tot/water_cp)/delta_t_allowed_water;
% find flow in m/s - this part is sketchy and I would like to recheck it, and the logic behind it
water_flow_cumecs = (g_water_heated)/1000000

function [heat_flux_leg] = find_heat_flux_leg(mesh_name, results, leg_height, res, thermal_conductivity)
    heat_flux_leg = 0;
     % in watts, this is per leg
    temp_previous = interpolateTemperature(results,0,0,0);

    for delta_h = leg_height/res : leg_height/res : leg_height
        area_at_point = find_area(delta_h, mesh_name);
        temp_at_point = interpolateTemperature(results, delta_h, 0, 0);
        delta_t = abs(temp_at_point - temp_previous);
        heat_flux_step = (thermal_conductivity*area_at_point*delta_t)/(leg_height/res);
        temp_previous = temp_at_point;
        heat_flux_leg = heat_flux_leg + heat_flux_step;
    end
end