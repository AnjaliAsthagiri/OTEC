function sim = calcPower(sim)
    pipe_pumping_pow = getPumpPowerPerPipe(sim);
    dElec_resistance = sim.TE_material.electrical_resistivity * sim.TE_material.thickness / (2*pi*sim.pipe.radius*sim.pipe.dX);
    pipe_pow = sum(arrayfun(@(x) powerfun(sim.hot_water.temperature - x, sim.TE_material.seebeck, dElec_resistance), sim.temperatures(1,:)));
    pump_pow_fraction = pipe_pumping_pow/pipe_pow;
    new_total_pow_needed = sim.total_power/(1-pump_pow_fraction);
    sim.power = struct("new", new_total_pow_needed, "pipe", pipe_pow, "pipe_pumping", pipe_pumping_pow);
end

function pipe_pump_pow = getPumpPowerPerPipe(sim)
    pressure = 8*sim.cold_water.dynamic_viscosity*sim.pipe.length*getPipeKgFlowRate(sim)/(pi*sim.pipe.radius^4);
    pipe_pump_pow = pressure*pi*sim.pipe.radius*sim.pipe.radius*sim.cold_water.velocity;
end

function pow = powerfun(dT, seebeck, elec_resistance)
    voltage = seebeck*dT;
    pow = voltage^2/(4*elec_resistance);
end