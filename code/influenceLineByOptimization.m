function [ influenceLine ] = influenceLineByOptimization( strainHistory, TrainData, SensorData)
% This function will find the optimal influence line based on the method of
% optimization
% The function will take in the given strain history, and the vehicles
% parameters.. this function aims to find the influence line that produces
% the most similar strain history to the actual strain history.. The
% resulting polynomial describing the influence line will give an optimized
% influence line for the given parameters.

% To achieve this, matlab's optimization toolbox will be used and in particular the inbuilt fminuc function 

% First some testing of fminuc
% fun = @(x) 3 + x^2;
% x0 = 1;
% [x, fval] = fminunc(fun, x0)
% inflFun = @(h)h;
% THE FOLLOWING GENERATES INFLUENCE LINE FOR A SINGLE MAGNITUDE, only
% unknown for optimization is h - magnitude of influence line


h1 = 1;

epsTh = @(h)(buildInflMatOptimization( TrainData, SensorData, h));
leastSquareFun = @(h)sum((strainHistory - epsTh(h))^2);
[h, fval] = fminunc(leastSquareFun, h1);
end

