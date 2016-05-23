function [ output_args ] = calculateAxleWeights( averaged, xvec, strainHistMat, TrainData, sensorLocs, sensor )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

C = axleDistancesInSamples(TrainData);
before = length(xvec(xvec<sensorLocs(sensor)));
after = length(xvec(xvec>=sensorLocs(sensor)));
% The first maximum peak of the strain signal should coincide with
% sensorLoc -> same length before sensorLoc as before
inflMat =  genInflMatFromCalcInflLine( averaged, length(TrainData.axleWeights), C);
[startStrain, endStrain, strainSignal] = fitStrainToInfl(strainHistMat(:,sensor), inflMat, averaged, C, before, after);
% strainSignal = strainHistMat(:,sensor);
strainSignal = strainSignal(startStrain:endStrain);
A = (inflMat\strainSignal);
sum(A)
end
