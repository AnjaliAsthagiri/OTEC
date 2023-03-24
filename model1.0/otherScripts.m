%%
h_res = 100;
lh_R_res = 20;
wl_R_res = 10;
base_R_res = 15;
height_arr = [];
length_arr = [];
width_arr = [];
base_R_arr = [];
ppm_arr = [];
p_cumec_arr = [];

for height = 0.0001 : (0.01- 0.0001)/h_res : 0.01
    for lengthR = 0.1 : (10-0.1)/lh_R_res : 10
        for widthR = 0.1 : (1-0.1)/wl_R_res : 1
            for baseR = 0.05 : (1 - 0.05)/base_R_res : 1  
                length = lengthR*height;
                width = widthR*length;
                small_length = baseR * length;
                small_width = baseR*width;
                [obj_tri, leg_height] = generateObjTri("Trapezoid", height, length, width, small_length, small_width, 0, 0); % leg height, hot face length, hot face width, cold face length, cold face width, middle length, middle width
                [~, real_temp_cold, real_temp_hot, ~, tm] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
                temp_diff = real_temp_hot-real_temp_cold;
                [num_modules, mod_power, mod_voltage, power_per_volume] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);
                height_arr(end+1) = height;
                length_arr(end+1) = length;
                width_arr(end+1) = width;
                base_R_arr(end+1) = baseR;
                ppm_arr(end+1) = mod_power;
                p_cumec_arr(end+1) = power_per_volume;
            end
        end
    end
end

%%
h_res = 100;
lh_R_res = 20;
wl_R_res = 10;
base_R_res = 15;
height_arr = [];
length_arr = [];
width_arr = [];
middle_R_arr = [];
ppm_arr = [];
p_cumec_arr = [];

for height = 0.0001 : (0.01- 0.0001)/h_res : 0.01
    for lengthR = 0.1 : (10-0.1)/lh_R_res : 10
        for widthR = 0.1 : (1-0.1)/wl_R_res : 1
            for middleR = 0.05 : (1 - 0.05)/base_R_res : 1  
                length = lengthR*height;
                width = widthR*length;
                small_length = middleR * length;
                small_width = middleR*width;
                [obj_tri, leg_height] = generateObjTri("Hourglass", height, length, width, length, width, small_length, small_width); % leg height, hot face length, hot face width, cold face length, cold face width, middle length, middle width
                [~, real_temp_cold, real_temp_hot, ~, tm] = generateThermalModel(obj_tri, leg_height, mod_therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp);
                temp_diff = real_temp_hot-real_temp_cold;
                [num_modules, mod_power, mod_voltage, power_per_volume] = findPower(obj_tri, tm, leg_height, temp_diff, mod_seebeck, mod_elec_resistivity, tot_power, 100);
                height_arr(end+1) = height;
                lenght_arr(end+1) = length;
                width_arr(end+1) = width;
                midde_R_arr(end+1) = middleR;
                ppm_arr(end+1) = mod_power;
                p_cumec_arr(end+1) = power_per_volume;
            end
        end
    end
end

%%
[widths, heights] = meshgrid(.001:0.001:.010, 0.001 : 0.001 : 0.01);

num_mods = [];
for leg_width = .001 : 0.001 : .010
    num_mods_new_col = [];
    for leg_height = 0.001 : 0.001 : 0.01
        Neumannboundarymodel;
        PowerCalculations;
        num_mods_new_col(end+1) = num_modules;
    end
    num_mods_new_col = num_mods_new_col';
    num_mods = [num_mods num_mods_new_col];
end

surf(widths, heights, num_mods)
xlabel("Width")
ylabel("Height")
zlabel("Num modules")

%% 

[widths, heights] = meshgrid(1 : 1 : 10, 0.001 : 0.001 : 0.01);

volumes = [];
for leg_width = .001 : 0.001 : .010
    volumes_new_col = [];
    for leg_height = 0.001 : 0.001 : 0.01
        Neumannboundarymodel;
        PowerCalculations;
        volumes_new_col(end+1) = tot_volume;
    end
    volumes_new_col = volumes_new_col';
    volumes = [volumes volumes_new_col];
end

surf(widths, heights, volumes)
xlabel("Width")
ylabel("Height")
zlabel("Total volume")

%% 

leg_width = 0.04;
num_mods = [];
heights = [];
for leg_height = 0.0001 : 0.0001 : 0.01
    Neumannboundarymodel;
    PowerCalculations;
    num_mods(end+1) = num_modules;
    heights(end+1) = leg_height;
end

plot(heights, num_mods)

%% GSW Toolbox Stuff
p_ref = 0;
long = 131.87;
lat = 32.28;

SP = [ 35  35  35  35  35  35  35  35  35  35  35  35 35  35  35  35  35  35  35  35  35  35  35  35  35  35  35	35  35  35  35  35  35  35  35  35  35  35  35 ]
t = [ 6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11  6.11 ]
p = [ 0.00  4.97  9.94  14.91  19.88  24.85  29.82  34.79  39.76  44.73  49.70  54.67  59.64  64.61  69.58  74.55  79.52  84.49  89.46  94.43  99.40  124.25  149.11  173.96  198.81  223.66  248.51  273.36  298.21  323.06  347.91  372.76  397.61  422.47  447.32  472.17  497.02  546.72  596.42 ]

SA = gsw_SA_from_SP(SP,p,long,lat);
CT = gsw_CT_from_t(SA,t,p);
density = gsw_rho(SA,CT,p)
density_potential = gsw_rho(SA,CT,p_ref)
