function sim = calcColdWaterTempChange(sim)
    cold_water_temp_change = 0;
    for i = 1 : size(sim.pipe.radius_arr,2)-1
        cold_water_temp_change = cold_water_temp_change + (pi*sim.pipe.dR*sim.pipe.dR + 2*pi*sim.pipe.radius_arr(i)*sim.pipe.dR)*sim.temperatures(i,end);
    end
    sim.cold_water_temp_change = cold_water_temp_change/(pi*sim.pipe.radius*sim.pipe.radius) - sim.cold_water.temperature;
end