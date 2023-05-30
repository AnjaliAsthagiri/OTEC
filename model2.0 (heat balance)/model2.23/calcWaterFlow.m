function sim = calcWaterFlow(sim)
    sim.total_kg_flow_rate = getPipeKgFlowRate(sim)*sim.TE_material_use.num_pipes;
end