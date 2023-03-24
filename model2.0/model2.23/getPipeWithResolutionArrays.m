function pipe = getPipeWithResolutionArrays(pipe)
    pipe.radius_arr = linspace(0,pipe.radius,101);
    pipe.length_arr = linspace(0,pipe.length,101);
    pipe.dR = pipe.radius_arr(2) - pipe.radius_arr(1);
    pipe.dX = pipe.length_arr(2) - pipe.length_arr(1);
end