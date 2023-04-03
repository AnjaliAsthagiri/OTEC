function calcCost()
    wall_thickness = 0.0015;
    CuNiAlloy_cost_kg = 10;
    outer_radius = data_matrix(:,1) + data_matrix(:,8) + wall_thickness*2;
    outer_TE_radius = data_matrix(:,1) + data_matrix(:,8) + wall_thickness;
    outer_innerwall_radius = data_matrix(:,1) + wall_thickness;

    outer_wall_volume_per_pipe = data_matrix(:,2) .* pi .* (outer_radius.^2 - outer_TE_radius.^2);
    inner_wall_volume_per_pipe = data_matrix(:,2) .* pi .* (outer_innerwall_radius.^2 - data_matrix(:,1).^2);
    total_wall_volume = (outer_wall_volume_per_pipe + inner_wall_volume_per_pipe) .* data_matrix(:,3);
    total_wall_cost = total_wall_volume .* 8490 .* CuNiAlloy_cost_kg;

    BiTe_cost_kg = 280;
    total_te_cost = data_matrix(:,4) .* 7700 .* BiTe_cost_kg;

    data_matrix(:,10) = total_te_cost + total_wall_cost;
end