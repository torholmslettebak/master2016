function [ influenceLine ] = influenceLineByOptimization( strainHistory, TrainData, sensorLoc, E, Z)
% THE FOLLOWING GENERATES A LINEAR INFLUENCE LINE FOR A SINGLE MAGNITUDE, only
% unknown for optimization is h - magnitudes of influence line

% disp(['Length of strain history: ' num2str(length(strainHistory))])
% h1 = [3 4 5 4 3];
h1= [1 2 1];
opts = optimoptions('fminunc','Algorithm','quasi-newton');
inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h));
leastSquareFun = @(h)sum((strainHistory - (1/(E*Z))*(inflMat(h)*transpose(TrainData.axleWeights))).^2);
[h, fval] = fminunc(leastSquareFun, h1, opts);
[~, influenceLine] = inflMat(h);
h
end

