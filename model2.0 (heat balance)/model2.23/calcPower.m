function sim = calcPower(sim)
    pipe_pumping_pow = getPumpPowerPerPipe(sim);
    pipe_pow = sum(arrayfun(@(x) powerfun(sim, sim.hot_water.temperature - x, sim.TE_material.seebeck, sim.pipe.dX), sim.temperatures(1,:)));
    pipe_voltage = sum(arrayfun(@(x) voltagefun(sim, sim.hot_water.temperature - x, sim.TE_material.seebeck, sim.pipe.dX), sim.temperatures(1,:)));
    pipe_elec_resistance = sim.TE_material.electrical_resistivity * sim.TE_material.thickness / (2*pi*sim.pipe.radius*sim.pipe.length);
    pipe_current = pipe_voltage/pipe_elec_resistance;
    pump_pow_fraction = pipe_pumping_pow/pipe_pow;
    new_total_pow_needed = sim.total_power/(1-pump_pow_fraction);
    sim.power = struct("new", new_total_pow_needed, "pipe", pipe_pow, "pipe_pumping", pipe_pumping_pow, "pipe_current", pipe_current, "pipe_resistance", pipe_elec_resistance, "pipe_voltage", pipe_voltage);
end

function pipe_pump_pow = getPumpPowerPerPipe(sim)
    pressure = 8*sim.cold_water.dynamic_viscosity*sim.pipe.length*getPipeKgFlowRate(sim)/(pi*sim.pipe.radius^4);
    pipe_pump_pow = pressure*pi*sim.pipe.radius*sim.pipe.radius*sim.cold_water.velocity;
end

function pow = powerfun(sim, dT, seebeck, dX)
    voltage = seebeck*dT;
    elec_resistance = sim.TE_material.electrical_resistivity * sim.TE_material.thickness / (2*pi*sim.pipe.radius*sim.pipe.dX);
    pow = voltage^2/(4*elec_resistance);
end
function voltage = voltagefun(sim, dT, seebeck, dX)
    voltage = seebeck*dT;
end