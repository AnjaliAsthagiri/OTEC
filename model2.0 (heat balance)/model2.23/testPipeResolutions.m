accuracyThreshold = 0.001;
simArr = [];
total_power = 500000;
hot_water = struct("temperature", 300.15);
TE_material = struct("thickness", 0.001, "thermal_conductivity", 1.4, "electrical_resistivity", 5.4945e-6, "seebeck", 162 * 10^-6, "cost_per_kg", 280, "kg_per_m3", 7700);

pipe_radius = [0.021];
pipe_length = [4.85];
cold_water_velocity = [0.1];
for i = 1 : size(pipe_radius)
    cold_water = struct("temperature", 279.15, "dynamic_viscosity", 1.73*10^-3, "specific_heat_capacity", 4184, "velocity", cold_water_velocity(i), "thermal_conductivity", 0.598);
    pipe = struct("length", pipe_length(i), "radius", pipe_radius(i), "wall_thickness", 0.0015, "cost_per_kg", 10, "kg_per_m3", 8490);
    for resolution = 10 : 500 : 5000
        pipe = getPipeWithResolutionArrays(pipe, resolution);
        sim = struct("total_power", total_power, "hot_water", hot_water, "cold_water", cold_water, "TE_material", TE_material, "pipe", pipe);
        sim = simulate(sim);
        simArr = addSimToArr(simArr, sim);
    end

    power_simArr = horzcat(vertcat(simArr.power).pipe);
    createGraph(horzcat(vertcat(simArr.pipe).resolution), power_simArr, "Pipe resolution", "Pipe power", "Pipe power v.s. Pipe resolution");
    disp(["pipe radius", pipe_radius(i), "pipe length", pipe_length(i), "cold water velocity", cold_water_velocity(i)])
    good_sim_lowest_res = simArr(find(power_simArr <= power_simArr(end)*(1+accuracyThreshold), 1));
    disp(["resolution", good_sim_lowest_res.pipe.resolution])
end
