function [results, real_temp_cold, real_temp_hot, temps, thermalmodel, heatFluxCold] = generateThermalModel(obj_tri, leg_height, therm_conductivity, hot_cc, cold_cc, hot_temp, cold_temp)
    % Neumann boundary model
    
    thermalmodel = createpde('thermal','steadystate');
    
    pts = obj_tri.Points;
    shp = alphaShape(pts(:,1),pts(:,2),pts(:,3),1);
    [elements,nodes] = boundaryFacets(shp);
    nodes = nodes';
    elements = elements';
    gm = geometryFromMesh(thermalmodel,nodes,elements);
    
    hotFace = nearestFace(gm, [0 0 0]);
    coldFace = nearestFace(gm, [leg_height 0 0]);
    
    % face at origin is hot end
    thermalProperties(thermalmodel, 'ThermalConductivity', therm_conductivity);
    thermalBC(thermalmodel,'Face', hotFace, 'ConvectionCoefficient', hot_cc, 'AmbientTemperature', hot_temp);
    thermalBC(thermalmodel,'Face', coldFace, 'ConvectionCoefficient', cold_cc, 'AmbientTemperature', cold_temp);

    generateMesh(thermalmodel, 'Hmin', 0.0000000001, 'Hmax', 10);
    results = solve(thermalmodel);
    
    heatFluxCold = evaluateHeatFlux(results, leg_height, 0, 0);

    %store temperature gradient in "temps" variable
    arr = [];
    arr0 = [];
    for i = 0 : leg_height/100 : leg_height
        arr(end+1) = i;
        arr0(end+1) = 0;
    end
    temps = interpolateTemperature(results, arr, arr0, arr0);
    
    %get the real temperatures of the cold and hot ends
    real_temp_cold = temps(end);
    real_temp_hot = temps(1);
    
    % plotting
    pdegplot(thermalmodel,'FaceLabels','on');
    pdeplot3D(thermalmodel, 'ColorMapData', results.Temperature(:, end))
    plot(arr, it)

end
