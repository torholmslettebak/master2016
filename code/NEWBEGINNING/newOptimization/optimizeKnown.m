function [ optimized ] = optimizeKnown(known_infl, strainSignal, TrainData, sensorLoc, length_infl, C)
%OPTIMIZEKNOWN Summary of this function goes here
%   Detailed explanation goes here
locs = 1:100:length(known_infl);
h1 = known_infl(locs);
% h1 = [peakLoc peakHeight stepSize];
inflMat = @(h)(buildInflMat( strainSignal, TrainData, h, length_infl, C ));
leastSquareFun = @(h) sum( (strainSignal - (inflMat(round(h))*transpose(TrainData.axleWeights))) ).^2;

[h, fval] = fmincon(leastSquareFun, h1);
end

