function sim = calcCost(sim)
    outer_innerwall_radius = sim.pipe.radius + sim.pipe.wall_thickness;
    outer_TE_radius = outer_innerwall_radius + sim.TE_material.thickness;
    outer_radius = outer_TE_radius + sim.pipe.wall_thickness;

    outer_wall_volume_per_pipe = sim.pipe.length * pi * (outer_radius^2 - outer_TE_radius^2);
    inner_wall_volume_per_pipe = sim.pipe.length * pi * (outer_innerwall_radius^2 - sim.pipe.radius^2);
    total_wall_volume = (outer_wall_volume_per_pipe + inner_wall_volume_per_pipe) * sim.TE_material_use.num_pipes;
    pipe_wall_cost = total_wall_volume * sim.pipe.kg_per_m3 * sim.pipe.cost_per_kg;

    TE_cost = sim.TE_material_use.total_material * sim.TE_material.kg_per_m3 * sim.TE_material.cost_per_kg;

    total_cost = TE_cost + pipe_wall_cost;
    sim.cost = struct("total_cost", total_cost, "TE_cost", TE_cost, "pipe_wall_cost", pipe_wall_cost);
end