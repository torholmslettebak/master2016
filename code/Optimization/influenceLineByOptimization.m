function [ influenceLine ] = influenceLineByOptimization( strainHistory, TrainData, sensorLoc, E, Z)
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

disp(['Length of strain history: ' num2str(length(strainHistory))])
% h1 = [3 4 5 4 3];
h1= [1 2 1 1 1];
opts = optimoptions('fminunc','Algorithm','quasi-newton');
inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h));
leastSquareFun = @(h)sum((strainHistory - (1/(E*Z))*(inflMat(h)*transpose(TrainData.axleWeights))).^2);
[h, fval] = fminunc(leastSquareFun, h1, opts);
[~, influenceLine] = inflMat(h);
h
end

