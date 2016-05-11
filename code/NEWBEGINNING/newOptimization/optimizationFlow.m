function [ initialInfl ] = optimizationFlow( strainSignal, TrainData, sensorLoc )
%OPTIMIZATIONFLOW Summary of this function goes here
%   Detailed explanation goes here

% FIRST do the initial optimization for identifying where max peak should
% be placed, how wide the peak should be at y=0, how tall should the peak
% be
C = axleDistancesInSamples(TrainData);
length_infl = length(strainSignal) - C(length(C));
initialInfl = initialOptimization(strainSignal, TrainData, length_infl, C);

end

