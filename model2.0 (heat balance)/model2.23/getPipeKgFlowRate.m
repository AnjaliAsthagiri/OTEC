function pipe_kg_flow_rate = getPipeKgFlowRate(sim)
    pipe_kg_flow_rate = sim.cold_water.velocity*pi*sim.pipe.radius*sim.pipe.radius*sim.cold_water.density;
end