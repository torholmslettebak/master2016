function [samplesBefore, samplesAfter] = findNecessarySamples( TrainData, sensorLoc )
%FINDNECESSARYSAMPLES Summary of this function goes here
%   Detailed explanation goes here
samplesBefore = round(sensorLoc+sum(TrainData.axleDistances) * (1/TrainData.delta)/TrainData.speed);
samplesAfter = round((TrainData.bridge_L - sensorLoc + sum(TrainData.axleDistances)) * (1/TrainData.delta)/TrainData.speed);

end

