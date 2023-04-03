function pipe_kg_flow_rate = getPipeKgFlowRate(sim)
    pipe_kg_flow_rate = sim.cold_water.velocity*pi*sim.pipe.radius*sim.pipe.radius*997; %TODO what is 997
end