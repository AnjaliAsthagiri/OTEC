%% STEADY STATE
thermalmodel = createpde('thermal','steadystate');
gm = importGeometry(thermalmodel, 'TRAPEZOID.stl');
thermalProperties(thermalmodel, 'ThermalConductivity', 1.4);
thermalBC(thermalmodel,'Face', 3, 'Temperature', 303.15);
thermalBC(thermalmodel,'Face', 6, 'Temperature', 278.15);

%thermalmodel.StefanBoltzmannConstant = 5.670367e-8;

mesh = generateMesh(thermalmodel);

results = solve(thermalmodel);

pdeplot3D(thermalmodel, 'ColorMapData', results.Temperature(:, end))


% GET TEMP AT SPECIFIC X
arr = [];
arr0 = [];
length = 6; % in mm
for i = 0 : length/100 : length
    arr(end+1) = i;
    arr0(end+1) = 0;
end
it = interpolateTemperature(results, arr, arr0, arr0);
plot(it)

%%
pdegplot(gm, 'FaceLabels', 'on') % to see face numbers of mesh


