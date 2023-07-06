function simArr = runSimulations(simArr_paramBounds)
    simArr = []; 
    total_power = 500000000; % total power desired for the entire plant in watts
    hot_water = struct("temperature", 300.15); 
    for pipe_radius = simArr_paramBounds.radius
        for pipe_length = simArr_paramBounds.length
            for cold_water_velocity = simArr_paramBounds.velocity
                for TE_material_thickness = simArr_paramBounds.thickness
                    cold_water = struct("temperature", 279.15, "dynamic_viscosity", 1.73*10^-3, "specific_heat_capacity", 4184, "velocity", cold_water_velocity, "thermal_conductivity", 0.598, "density", 997);
                    TE_material = struct("thickness", TE_material_thickness, "thermal_conductivity", 1.4, "electrical_resistivity", 5.4945e-6, "seebeck", 160 * 10^-6 + 170 * 10^-6, "cost_per_kg", 280, "kg_per_m3", 7700);
                    
                    pipe = struct("length", pipe_length, "radius", pipe_radius, "wall_thickness", 0.0015, "cost_per_kg", 10, "kg_per_m3", 8490, "roughness", 0.002, "hazen_williams_coefficient", 140);
                    pipe_resolution = struct("length_resolution", 7000, "radius_initial_res", 0.0001, "radius_exp_base", 1.0001);
                    pipe = getPipeWithResolutionArrays(pipe, pipe_resolution);
                    
                    sim = struct("total_power", total_power, "load_resistance", 0, "hot_water", hot_water, "cold_water", cold_water, "TE_material", TE_material, "pipe", pipe);
                    % TODO: load resistance
                    sim = simulate(sim);
                    simArr = addSimToArr(simArr, sim);
                end
            end
        end
    end
end

function simArr = addSimToArr(simArr, sim)
    if(size(simArr, 2) == 0)
        simArr = sim;
    else
        simArr(end+1) = sim;
    end
end