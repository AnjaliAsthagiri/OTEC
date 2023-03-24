%% CONSTANTS
p_therm_conductivity = 1.3;
n_therm_conductivity = 1.5;
mod_therm_conductivity = (p_therm_conductivity+n_therm_conductivity)/2;

p_elec_resistivity = 5.4945e-6;
n_elec_resistivity = 5.4945e-6;
mod_elec_resistivity = p_elec_resistivity + n_elec_resistivity;

p_seebeck = 162 * 10^-6;
n_seebeck = -162 * 10^-6;
mod_seebeck = p_seebeck - n_seebeck;

tot_power = 500000000;

cold_cc = 10000;
hot_cc = 5000;

allowed_dt_cold_water = 9; % oC
specific_heat_capacity_water = 4184; % j/(kg*oC)

cold_temp = (279.15+(279.15+allowed_dt_cold_water))/2; %used to be 278.15 (up until sim 16)
hot_temp = 300.15; %used to be 303.15 (up until sim 15)

% dist_from_pipeedge_heated = .001; %TODO: need good # for this

%% RECTANGLE
h_res = 1; % 100
lh_R_res = 1; % 20 
wl_R_res = 100; % 10
allowed_dt_res = 1;

vpm_arr = zeros([1 lh_R_res*h_res*wl_R_res*allowed_dt_res]);
height_arr = vpm_arr;
length_arr = vpm_arr;
width_arr = vpm_arr;
ppm_arr = vpm_arr;
p_cumec_arr = vpm_arr;
temp_diff_arr = vpm_arr;
mod_volume_arr = vpm_arr;
tot_heat_transfer_arr = vpm_arr;
num_modules_arr = vpm_arr;
heat_flux_cold_end_arr = vpm_arr;
kg_water_pump_per_sec_arr = vpm_arr;
allowed_dt_cold_water_arr = vpm_arr;
cold_temp_arr = vpm_arr;

count = 1;
%for allowed_dt_cold_water = .5 : (26.5-.5)/(allowed_dt_res-1) : 26.5
%for lengthR = 0.1 : (100-0.1)/(lh_R_res-1) : 100
    %for height = 0.0001 : (0.1 - 0.0001)/(h_res-1) : 0.1
	% for widthR = 0.1 : (1-0.1)/(wl_R_res-1) : 1
    for width = 0.000025 : (1 - .000025)/(wl_R_res-1) : 1 % 0.000025
            length = width;
            height = .0011;
            %length = lengthR*height;
            %width = widthR*length;
            cold_temp = (279.15+(279.15+allowed_dt_cold_water))/2;
            
            [obj_tri, leg_height] = generateObjTri("Rectangle", height, length, width, length, width, 0, 0); % leg height, hot face L, hot face W, cold face L, cold face W, mid L, mid W
            [~, real_temp_cold, real_temp_hot, ~, tm, heat_flux_coldend] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
            temp_diff = real_temp_hot-real_temp_cold;
            [num_modules, mod_power, mod_voltage, power_per_volume, mod_volume] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);
            total_heat_transfer = heat_flux_coldend * (length*width*2) * num_modules;
            kg_water_pump_per_sec = total_heat_transfer/(specific_heat_capacity_water*allowed_dt_cold_water);
            
            height_arr(count) = height;
            length_arr(count) = length;
            width_arr(count) = width;
            ppm_arr(count) = mod_power;
            p_cumec_arr(count) = power_per_volume;
            vpm_arr(count) = mod_voltage;
            mod_volume_arr(count) = mod_volume;
            temp_diff_arr(count) = temp_diff;
            tot_heat_transfer_arr(count) = total_heat_transfer;
            kg_water_pump_per_sec_arr(count) = kg_water_pump_per_sec;
            num_modules_arr(count) = num_modules;
            heat_flux_cold_end_arr(count) = heat_flux_coldend;
            allowed_dt_cold_water_arr(count) = allowed_dt_cold_water;
            cold_temp_arr(count) = cold_temp;
            disp(count)
            count = count + 1;
        %end
    end
%end
save('Sept5_RectangleDataSim20_WidthData_Height0.0011DT9.mat', 'kg_water_pump_per_sec_arr', 'heat_flux_cold_end_arr', 'tot_heat_transfer_arr', 'num_modules_arr', 'mod_volume_arr', 'temp_diff_arr', 'vpm_arr', 'height_arr', 'length_arr', 'width_arr', 'ppm_arr', 'p_cumec_arr', 'count', 'lh_R_res', 'wl_R_res', 'h_res', 'allowed_dt_res', 'allowed_dt_cold_water_arr', 'cold_temp_arr');

%% Surf plot
width_m = reshape(width_arr', lh_R_res, (count-1)/lh_R_res, []); % Y
length_m = reshape(length_arr', lh_R_res, (count-1)/lh_R_res, []); % X
height_m = reshape(height_arr', lh_R_res, (count-1)/lh_R_res, []); % Z
p_cumec_m = reshape(p_cumec_arr', lh_R_res, (count-1)/lh_R_res, []);

s = surf(length_m, width_m, height_m, p_cumec_m);
s.CData = p_cumec_m;
s.EdgeColor = 'none';

xlabel('length')
ylabel('height')
zlabel('width')
disCVal(f, p_cumec_m);

%% 2D plots

scatter(allowed_dt_cold_water_arr, kg_water_pump_per_sec_arr);
xlabel('allowed temp change of cold end')
ylabel('kg water to pump')
figure;
scatter(allowed_dt_cold_water_arr, tot_heat_transfer_arr);
xlabel('allowed temp change of cold end')
ylabel('tot heat transfer')
figure;
scatter(allowed_dt_cold_water_arr, p_cumec_arr);
xlabel('allowed temp change of cold end')
ylabel('power per volume')
figure;
scatter(tot_volume_arr, tot_heat_transfer_arr);
xlabel('tot volume')
ylabel('tot heat transfer arr')
figure;
scatter(height_arr, ppm_arr);
xlabel('height')
ylabel('ppm')
figure;
scatter(width_arr, mod_volume_arr);
xlabel('width')
ylabel('mod volume')
scatter(height_arr, temp_diff_arr);
xlabel('height')
ylabel('temp diff')
scatter(width_arr, p_cumec_arr);
xlabel('width')
ylabel('Power per volume')

%% Scatter plot
f = figure('Name', 'f1');
sc = scatter3(length_arr, width_arr, height_arr, 40, temp_diff_arr,'filled')
% s = surf(length_m, width_m, height_m, ppm_m);
% s.CData = ppm_m;
% s.EdgeColor = 'none';
ylabel('length')
xlabel('width')
zlabel('height')
disCVal(f, temp_diff_arr);

%% TRAPEZOID
h_res = 3;
lh_R_res = 3; % 20 
wl_R_res = 3; % 10
base_R_res = 3;

vpm_arr = zeros([1 lh_R_res*h_res*wl_R_res*base_R_res]);
height_arr = vpm_arr;
top_length_arr = vpm_arr;
top_width_arr = vpm_arr;
ppm_arr = vpm_arr;
p_cumec_arr = vpm_arr;
base_R_arr = vpm_arr;
temp_diff_arr = vpm_arr;

count = 1;
for height = 0.0001 : (0.01- 0.0001)/h_res : 0.01
    for lengthR = 0.1 : (10-0.1)/lh_R_res : 10
        for widthR = 0.1 : (1-0.1)/wl_R_res : 1
            for baseR = 0.05 : (1 - 0.05)/base_R_res : 1  
                length = lengthR*height;
                width = widthR*length;
                small_length = baseR*length;
                small_width = baseR*width;
                [obj_tri, leg_height] = generateObjTri("Trapezoid", height, length, width, small_length, small_width, 0, 0); % leg height, hot face length, hot face width, cold face length, cold face width, middle length, middle width
                [~, real_temp_cold, real_temp_hot, ~, tm] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
                temp_diff = real_temp_hot-real_temp_cold;
                [~, mod_power, mod_voltage, power_per_volume] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);
                height_arr(count) = height;
                top_length_arr(count) = length;
                top_width_arr(count) = width;
                base_R_arr(count) = baseR;
                ppm_arr(count) = mod_power;
                vpm_arr(count) = mod_voltage;
                p_cumec_arr(count) = power_per_volume;
                temp_diff_arr(count) = temp_diff;
                disp(count)
                count = count + 1;
            end
        end
    end
end
save('TrapezoidDataSim1.mat', 'temp_diff_arr', 'base_R_arr', 'vpm_arr', 'height_arr', 'top_length_arr', 'top_width_arr', 'ppm_arr', 'p_cumec_arr', 'count', 'lh_R_res', 'wl_R_res', 'h_res');

%% Scatter plot
f = figure('Name', 'f1');
sc = scatter3(top_length_arr, top_width_arr, height_arr, 40, ppm_arr,'filled')
% s = surf(length_m, width_m, height_m, ppm_m);
% s.CData = ppm_m;
% s.EdgeColor = 'none';
ylabel('length')
xlabel('width')
zlabel('height')
disCVal(f, ppm_arr);

%% SAMPLE CODE
[obj_tri, leg_height] = generateObjTri("Trapezoid", 0.006, 0.002, 0.002, 0.004, 0.004, 0, 0); % leg height, hot face L, hot face W, cold face L, cold face W, mid L, mid W
[~, real_temp_cold, real_temp_hot, ~, tm] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
temp_diff = real_temp_hot-real_temp_cold;
[num_modules, mod_power, mod_voltage, power_per_volume] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);

%% SHAPES
height = 0.006;
width = 0.004;
length = 0.004;
[obj_tri, leg_height] = generateObjTri("Rectangle", height, length, width, length, width, 0, 0); % leg height, hot face L, hot face W, cold face L, cold face W, mid L, mid W
[~, real_temp_cold, real_temp_hot, ~, tm, heat_flux_coldend] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
temp_diff = real_temp_hot-real_temp_cold;
[num_modules_rect, mod_power_rect, mod_voltage_rect, power_per_volume_rect, mod_volume_rect] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);
tot_heat_transfer_per_mod_rect = heat_flux_coldend * (length*width);

[obj_tri, leg_height] = generateObjTri("Trapezoid", height, length/2, width/2, length, width, 0, 0); % leg height, hot face L, hot face W, cold face L, cold face W, mid L, mid W
[~, real_temp_cold, real_temp_hot, ~, tm, heat_flux_coldend] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
temp_diff = real_temp_hot-real_temp_cold;
[num_modules_trap, mod_power_trap, mod_voltage_trap, power_per_volume_trap, mod_volume_trap] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);
tot_heat_transfer_per_mod_trap = heat_flux_coldend * (length*width);

[obj_tri, leg_height] = generateObjTri("Trapezoid", height, length, width, length/2, width/2, 0, 0); % leg height, hot face L, hot face W, cold face L, cold face W, mid L, mid W
[~, real_temp_cold, real_temp_hot, ~, tm, heat_flux_coldend] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
temp_diff = real_temp_hot-real_temp_cold;
[num_modules_itrap, mod_power_itrap, mod_voltage_itrap, power_per_volume_itrap, mod_volume_itrap] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);
tot_heat_transfer_per_mod_itrap = heat_flux_coldend * (length*width);

[obj_tri, leg_height] = generateObjTri("Hourglass", height, length, width, length, width, length/2, width/2); % leg height, hot face L, hot face W, cold face L, cold face W, mid L, mid W
[~, real_temp_cold, real_temp_hot, ~, tm, heat_flux_coldend] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
temp_diff = real_temp_hot-real_temp_cold;
[num_modules_hour, mod_power_hour, mod_voltage_hour, power_per_volume_hour, mod_volume_hour] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);
tot_heat_transfer_per_mod_hour = heat_flux_coldend * (length*width);
