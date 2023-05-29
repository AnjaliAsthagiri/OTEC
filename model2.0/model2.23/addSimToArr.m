function simArr = addSimToArr(simArr, sim)
    if(size(simArr, 2) == 0)
        simArr = sim;
    else
        simArr(end+1) = sim;
    end
end