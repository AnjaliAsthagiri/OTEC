runSimulations;

createGraph(horzcat(vertcat(simArr.pipe).radius), horzcat(vertcat(simArr.power).new), "Pipe radius", "Power new", "Power new v.s. Pipe radius");
createGraph(horzcat(vertcat(simArr.pipe).length), horzcat(vertcat(simArr.power).new), "Pipe length", "Power new", "Power new v.s. Pipe length");
createGraph(horzcat(vertcat(simArr.pipe).radius), horzcat(simArr.efficiency), "Pipe radius", "Efficiency", "Efficiency v.s. Pipe radius");
createGraph(horzcat(vertcat(simArr.pipe).length), horzcat(simArr.efficiency), "Pipe length", "Efficiency", "Efficiency v.s. Pipe length");
createGraph(horzcat(vertcat(simArr.pipe).radius), horzcat(vertcat(simArr.TE_material_use).total_material), "Pipe radius", "Total TE material", "Total TE material v.s. Pipe radius");
createGraph(horzcat(vertcat(simArr.pipe).length), horzcat(vertcat(simArr.TE_material_use).total_material), "Pipe length", "Total TE material", "Total TE material v.s. Pipe length");

createGraph(horzcat(vertcat(simArr.pipe).resolution), horzcat(vertcat(simArr.power).new), "Pipe resolution", "Power new", "Power new v.s. Pipe resolution");

% save("simulation", simArr); % TODO

imagesc(sim.pipe.length_arr,sim.pipe.radius_arr,sim.temperatures);
set(gca, 'YDir', 'normal');
colorbar
ylabel('Radius (m)', 'FontName', 'Arial', 'FontSize', 20)
xlabel('Distance from Pipe Inlet (m)','FontName', 'Arial', 'FontSize', 20)
title('Temperature Distribution within Pipe', 'FontName', 'Arial', 'FontSize', 30,'FontWeight','Normal')