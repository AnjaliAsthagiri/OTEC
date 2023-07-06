function sim = calcColdWaterTempChange(sim)
    cold_water_temp_change = 0;
    for i = 1 : size(sim.pipe.radius_arr,2)-1
        outerRadius = sim.pipe.radius_arr(i+1);
        innerRadius = sim.pipe.radius_arr(i);
        avgTemp = (sim.temperatures(i,end) + sim.temperatures(i+1,end))/2;
        cold_water_temp_change = cold_water_temp_change + pi*(outerRadius*outerRadius - innerRadius*innerRadius)*avgTemp;
    end
    sim.cold_water_temp_change = cold_water_temp_change/(pi*sim.pipe.radius*sim.pipe.radius) - sim.cold_water.temperature;
end