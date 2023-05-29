simArr = [];

total_power = 500000;
hot_water = struct("temperature", 300.15);
for pipe_radius = 1
    for pipe_length = 1
        for cold_water_velocity = .1
            for TE_material_thickness = 0.001
                for resolution = 101
                    cold_water = struct("temperature", 279.15, "dynamic_viscosity", 1.73*10^-3, "specific_heat_capacity", 4184, "velocity", cold_water_velocity, "thermal_conductivity", 0.598);
                    TE_material = struct("thickness", TE_material_thickness, "thermal_conductivity", 1.4, "electrical_resistivity", 5.4945e-6, "seebeck", 162 * 10^-6, "cost_per_kg", 280, "kg_per_m3", 7700);
                    pipe = struct("length", pipe_length, "radius", pipe_radius, "wall_thickness", 0.0015, "cost_per_kg", 10, "kg_per_m3", 8490);
                    pipe = getPipeWithResolutionArrays(pipe, resolution);
                    
                    sim = struct("total_power", total_power, "hot_water", hot_water, "cold_water", cold_water, "TE_material", TE_material, "pipe", pipe);
                    sim = simulate(sim);
                    simArr = addSimToArr(simArr, sim);
                end
            end
        end
    end
end