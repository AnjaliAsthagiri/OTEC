% that takes in all constant/parameter values (multiple values = parameter, one value = constant) 
    ... and whether to save data locally
        
function sim = simulate(sim)
    sim = calcTempDistribution(sim);
%     sim = calcColdWaterTempChange(sim);
    sim = calcPower(sim);
    
    sim = calcTEMaterialUse(sim);
    sim = calcWaterFlow(sim);
    sim = calcEfficiency(sim);
    sim = calcCost(sim);
end