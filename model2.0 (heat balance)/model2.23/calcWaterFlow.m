function sim = calcWaterFlow(sim)
    sim.total_kg_flow_rate = getKgFlowRate(sim)*sim.TE_material_use.num_pipes;
end