function [ Eps ] = speedOptHelpFun( speed, strainHistMat, sensorLocs, numberOfSensors, sensor )
%SPEEDOPTHELPFUN Summary of this function goes here
%   Detailed explanation goes here
    TrainData = makeTrain(speed, 0);
    [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
    Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights); 
    speed
    figure(1)
    plot(1:length(strainHistMat(:,1)), strainHistMat(:,1), 1:length(strainHistMat(:,1)), Eps)
%     close(1);
    figure(2)
    plot(1:length(InfluenceLines(:,1)), InfluenceLines(:,1));
    
end

