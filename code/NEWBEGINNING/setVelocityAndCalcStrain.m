function [ Eps ] = setVelocityAndCalcStrain( TrainData, strainHistMat, sensorLocs, numberOfSensors,v )
%SETVELOCITYANDCALCSTRAIN Summary of this function goes here
%   Detailed explanation goes here
TrainData = makeTrain(v);
[InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights);
end

