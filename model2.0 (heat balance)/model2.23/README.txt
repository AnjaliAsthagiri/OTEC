**simulate**

**createGraphs**

**calcColdWaterTempChange**
    RETURNS sim
        CREATES sim.cold_water_temp_change

**calcCost**
    RETURNS sim
        CREATES sim.cost = struct("total_cost", total_cost, "TE_cost", TE_cost, "pipe_wall_cost", pipe_wall_cost);

**calcEfficiency**
    RETURNS sim
        CREATES sim.efficiency

**calcPower**
    RETURNS sim
        CREATES sim.power = struct("net", net_total_pow, "pipe", pipe_pow, "pipe_pumping", pipe_pumping_pow);

**calcTEMaterialUse**
    RETURNS sim
        CREATES sim.TE_material_use = struct("num_pipes", num_pipes, "total_material", tot_material);

**calcTempDistribution**
    RETURNS sim
        CREATES sim.temperatures

**calcWaterFlow**
    RETURNS sim
        CREATES sim.total_kg_flow_rate

**getPipeKgFlowRate**
    RETURNS pipe_kg_flow_rate

**getPipeWithResolutionArrays**
    RETURNS pipe
        CREATES .dR, .dX, length_arr, radius_arr