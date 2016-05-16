function [ initialInfl ] = optimizationFlow( strainSignal, TrainData, sensorLoc, known_infl )
%OPTIMIZATIONFLOW Summary of this function goes here
%   Detailed explanation goes here

% FIRST do the initial optimization for identifying where max peak should
% be placed, how wide the peak should be at y=0, how tall should the peak
% be
C = axleDistancesInSamples(TrainData);
length_infl = length(strainSignal) - C(length(C));
if nargin >3 % An influence line has been found through the matrix method
    optimized_found = optimizeKnown(known_infl, strainSignal, TrainData, sensorLoc,length_infl, C);
else
    initialInfl = initialOptimization(strainSignal, TrainData, length_infl, C);
end
end

