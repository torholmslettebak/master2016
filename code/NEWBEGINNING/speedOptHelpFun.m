function [ Eps ] = speedOptHelpFun( speed, strainHistMat, sensorLocs, numberOfSensors, sensor )
%SPEEDOPTHELPFUN Summary of this function goes here
%   Detailed explanation goes here
    TrainData = makeTrain(speed);
    [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
    Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights); 

end

