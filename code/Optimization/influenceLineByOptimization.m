function [ influenceLine ] = influenceLineByOptimization( strainHistory, TrainData, sensorLoc, E, Z, type)
% THE FOLLOWING GENERATES A LINEAR INFLUENCE LINE FOR A SINGLE MAGNITUDE, only
% unknown for optimization is h - magnitudes of influence line

if ~isempty(type)
    if strcmp(type, 'linear')
        h1= 0:TrainData.bridge_L;
        inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type));
    elseif strcmp(type, 'polynomial')
        h1 = 0:TrainData.bridge_L;
        inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type));
    else
        %     No known type offered - > Do linear
        h1= 0:TrainData.bridge_L;
        inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type));
    end
else
    h1= 0:TrainData.bridge_L;
    inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type));
end

opts = optimoptions('fminunc','Algorithm','quasi-newton');

leastSquareFun = @(h)sum((strainHistory - (1/(E*Z))*(inflMat(h)*transpose(TrainData.axleWeights))).^2);
[h, fval] = fminunc(leastSquareFun, h1, opts);
[~, influenceLine] = inflMat(h);
h
end

