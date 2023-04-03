function sim = calcTEMaterialUse(sim)
    num_pipes = sim.power.net/sim.power.pipe;
    tot_material = (pi*sim.TE_material.thickness*sim.TE_material.thickness + 2*pi*sim.pipe.radius*sim.TE_material.thickness)*sim.pipe.length*num_pipes;
    sim.TE_material_use = struct("num_pipes", num_pipes, "total_material", tot_material);
end