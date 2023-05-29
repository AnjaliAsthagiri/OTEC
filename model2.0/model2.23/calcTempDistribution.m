function sim = calcTempDistribution(sim)
    m = 1;
    temps_raw = pdepe(m, @pdefun, @icfun, @bcfun, sim.pipe.radius_arr, sim.pipe.length_arr, [], sim.hot_water, sim.cold_water, sim.TE_material);
    sim.temperatures = flipud(temps_raw)';
end

function [c,f,s] = pdefun(r,x,u,dudr,hot_water, cold_water, TE_material)
    c = cold_water.velocity*cold_water.specific_heat_capacity*1000;
    f = dudr*cold_water.thermal_conductivity;
    s = 0;
end

function u0 = icfun(r, hot_water, cold_water, TE_material)
    u0 = cold_water.temperature;
end

function [pL,qL,pR,qR] = bcfun(rL,uL,rR,uR,x, hot_water, cold_water, TE_material)
    pL = 0;
    qL = 1;
    pR = -TE_material.thermal_conductivity/TE_material.thickness*(hot_water.temperature-uR);
    qR = cold_water.thermal_conductivity;
end