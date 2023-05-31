simArr = [];
%%
total_power = 500000;
resolution = 1000;
hot_water = struct("temperature", 300.15);

for pipe_radius = [.001 : .04 : .1, .1 : .5 : 3]
    for pipe_length = .1 : .5 : 4
        for cold_water_velocity = [.01 : .05 : .21, .3 : .5 : 1.8]
            for TE_material_thickness = 0.001
% for pipe_radius = 0.25
%     for pipe_length = [.1, 5]
%         for cold_water_velocity = [.01, 2.5]
%             for TE_material_thickness = 0.001
                cold_water = struct("temperature", 279.15, "dynamic_viscosity", 1.73*10^-3, "specific_heat_capacity", 4184, "velocity", cold_water_velocity, "thermal_conductivity", 0.598, "density", 997);
                TE_material = struct("thickness", TE_material_thickness, "thermal_conductivity", 1.4, "electrical_resistivity", 5.4945e-6, "seebeck", 160 * 10^-6 + 170 * 10^-6, "cost_per_kg", 280, "kg_per_m3", 7700);
                pipe = struct("length", pipe_length, "radius", pipe_radius, "wall_thickness", 0.0015, "cost_per_kg", 10, "kg_per_m3", 8490, "roughness", 0.002, "hazen_williams_coefficient", 140);
                pipe = getPipeWithResolutionArrays(pipe, resolution);

                sim = struct("total_power", total_power, "load_resistance", 0, "hot_water", hot_water, "cold_water", cold_water, "TE_material", TE_material, "pipe", pipe);
                sim = simulate(sim);
                simArr = addSimToArr(simArr, sim);
            end
        end
    end
end