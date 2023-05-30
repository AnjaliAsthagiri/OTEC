function sim = calcEfficiency(sim)
    %energy lost through thermal conductance & electrical resistance -
    %assuming max power/efficiency
%     sim.Q_out = sim.cold_water.specific_heat_capacity*sim.total_kg_flow_rate*sim.cold_water_temp_change + sim.power.new;
    %energy lost + energy generated
%     sim.Q_in = sim.Q_out + sim.power.new;

    %textbook equation
    sim.Q_in = sim.cold_water.specific_heat_capacity*sim.total_kg_flow_rate*sim.cold_water_temp_change + sim.TE_material.seebeck*sim.power.pipe_current*sim.hot_water.temperature;
    %total efficiency
    sim.efficiency = sim.total_power/sim.Q_in;

%     carnot_eff = (sim.hot_water.temperature-sim.cold_water.temperature)/sim.hot_water.temperature;
%     temp_avg = (sim.hot_water.temperature + sim.cold_water.temperature)/2;
%     zT_figure_of_merit = temp_avg*sim.TE_material.seebeck^2*sim.TE_material.electrical_resistivity/sim.TE_material.thermal_conductivity;
%     sim.max_efficiency = ((sim.hot_water.temperature-sim.cold_water.temperature)/sim.hot_water.temperature)*((sqrt(1+zT_figure_of_merit)-1)/(sqrt(1+zT_figure_of_merit)+sim.cold_water.temperature/sim.hot_water.temperature));
%     sim.real_efficiency = 
%     sim.zT_figure_of_merit = zT_figure_of_merit;
%     sim.carnot_eff = carnot_eff;
%     sim.total_heat_input = total_heat_input;
end