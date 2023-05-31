function sim = calcPower(sim)
    pipe_pumping_pow = getPumpPowerPerPipe(sim);
    pipe_pow = sum(arrayfun(@(x) powerfun(sim, sim.hot_water.temperature - x, sim.TE_material.seebeck, sim.pipe.dX), sim.temperatures(1,:)));
    pipe_voltage = sum(arrayfun(@(x) voltagefun(sim, sim.hot_water.temperature - x, sim.TE_material.seebeck, sim.pipe.dX), sim.temperatures(1,:)));
    pipe_elec_resistance = sim.TE_material.electrical_resistivity * sim.TE_material.thickness / (2*pi*sim.pipe.radius*sim.pipe.length);
    pipe_current = pipe_voltage/pipe_elec_resistance;
    pump_pow_fraction = pipe_pumping_pow/pipe_pow;
    new_total_pow_needed = sim.total_power*(1-pump_pow_fraction);
    sim.power = struct("new", new_total_pow_needed, "pipe", pipe_pow, "pipe_pumping", pipe_pumping_pow, "pipe_current", pipe_current, "pipe_resistance", pipe_elec_resistance, "pipe_voltage", pipe_voltage);
end

function pipe_pump_pow = getPumpPowerPerPipe(sim)
    if(sim.reynolds_number > 4000)
        a = 2/log(10);
        b = sim.pipe.roughness/(2*sim.pipe.radius*3.7);
        d = log(10)*sim.reynolds_number/5.02;
        s = b*d + log(d);
        q = s^(s/(s+1));
        g = b*d + log(d/q);
        z = log(q/g);
        D_la = z*g/(g+1);
        D_cfa = D_la*(1+(z/2)/((g+1)^2+(z/3)*(2*g-1)));
        f = (1/(a*(log(d/q)+D_cfa)))^2;
        
        %Goudar-Sonnad approximation
        pressure = sim.cold_water.density*f*sim.pipe.length*sim.cold_water.velocity^2/(2*2*sim.pipe.radius);
%         pressure_Hazen = 10.67*(getPipeKgFlowRate(sim)/sim.cold_water.density)^1.852 / (sim.pipe.hazen_williams_coefficient^1.852*(2*sim.pipe.radius)^4.8704);
    else
        pressure = 8*sim.cold_water.dynamic_viscosity*sim.pipe.length*getPipeKgFlowRate(sim)/(pi*sim.pipe.radius^4*sim.cold_water.density);
    end
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