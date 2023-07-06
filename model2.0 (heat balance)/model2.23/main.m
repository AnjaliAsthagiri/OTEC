runSimulations;
%%
simArrFilt = simArr;
%% Negative new power
simArrFilt = simArrFilt(horzcat(vertcat(simArrFilt.power).new) > 0);
%%
simArrFilt = simArrFilt(horzcat(vertcat(simArrFilt.pipe).radius) == 0.1);
%%
simArrFilt = simArrFilt(horzcat(vertcat(simArrFilt.pipe).length) == 1.1);
%%
simArrFilt = simArrFilt(horzcat(vertcat(simArrFilt.cold_water).velocity) == 0.6);
%%
simArrFilt = simArrFilt(horzcat(vertcat(simArrFilt.TE_material).thickness) == 0.001);
%%
createGraph(horzcat(vertcat(simArrFilt.pipe).radius), horzcat(vertcat(simArrFilt.power).new), "Pipe radius", "Power new", "Power new v.s. Pipe radius");
createGraph(horzcat(vertcat(simArrFilt.pipe).length), horzcat(vertcat(simArrFilt.power).new), "Pipe length", "Power new", "Power new v.s. Pipe length");
createGraph(horzcat(vertcat(simArrFilt.pipe).radius), horzcat(simArrFilt.netefficiency), "Pipe radius", "Efficiency", "Efficiency v.s. Pipe radius");
createGraph(horzcat(vertcat(simArrFilt.pipe).length), horzcat(simArrFilt.netefficiency), "Pipe length", "Efficiency", "Efficiency v.s. Pipe length");
createGraph(horzcat(vertcat(simArrFilt.pipe).radius), horzcat(vertcat(simArrFilt.TE_material_use).total_material), "Pipe radius", "Total TE material", "Total TE material v.s. Pipe radius");
createGraph(horzcat(vertcat(simArrFilt.pipe).length), horzcat(vertcat(simArrFilt.TE_material_use).total_material), "Pipe length", "Total TE material", "Total TE material v.s. Pipe length");
createGraph(horzcat(simArrFilt.total_kg_flow_rate), horzcat(vertcat(simArrFilt.TE_material_use).total_material), "Total TE material", "Cold Water Kg Flow Rate", "Total TE material v.s. Cold Water Kg Flow Rate", horzcat(simArrFilt.netefficiency));
createGraph(horzcat(simArrFilt.total_kg_flow_rate), horzcat(vertcat(simArrFilt.TE_material_use).total_material), "Total TE material", "Cold Water Kg Flow Rate", "Total TE material v.s. Cold Water Kg Flow Rate", horzcat(vertcat(simArrFilt.pipe).radius));
scatter3(horzcat(simArrFilt.total_kg_flow_rate), horzcat(vertcat(simArrFilt.TE_material_use).total_material), 1:size(simArrFilt, 2), [], horzcat(vertcat(simArrFilt.pipe).radius));
xlabel("Total TE material"); ylabel("Cold Water Kg Flow Rate"); title("Cold Water Kg Flow Rate v.s. Total TE material");
% save('simulation', 'simArr');
%%
imagesc(sim.pipe.length_arr,sim.pipe.radius_arr,sim.temperatures);
set(gca, 'YDir', 'normal');
colorbar
ylabel('Radius (m)', 'FontName', 'Arial', 'FontSize', 20)
xlabel('Distance from Pipe Inlet (m)','FontName', 'Arial', 'FontSize', 20)
title('Temperature Distribution within Pipe', 'FontName', 'Arial', 'FontSize', 30,'FontWeight','Normal')
%%
simArrWithReynolds = arrayfun(@(x) addReynolds(x), simArr);
%%
function [sim] = addReynolds(sim)
    sim.reynolds_number = (sim.cold_water.density * sim.cold_water.velocity * 2*sim.pipe.radius)/sim.cold_water.dynamic_viscosity;
end