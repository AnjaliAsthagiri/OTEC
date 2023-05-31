function sim = calcReynoldsNumber(sim)
    sim.reynolds_number = (sim.cold_water.density * sim.cold_water.velocity * 2*sim.pipe.radius)/sim.cold_water.dynamic_viscosity;
end