function [ output_args ] = calculateAxleWeights( averaged, xvec, strainHistMat, TrainData, sensorLocs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

C = axleDistancesInSamples(TrainData)
before = length(xvec(xvec<sensorLocs(1)));
after = length(xvec(xvec>=sensorLocs(1)));
% The first maximum peak of the strain signal should coincide with
% sensorLoc -> same length before sensorLoc as before
inflMat =  genInflMatFromCalcInflLine( averaged, length(TrainData.axleWeights), C);
[startStrain, endStrain] = fitStrainToInfl(strainHistMat(:,1), inflMat, averaged, C, before, after);
strainSignal = strainHistMat(:,1);
strainSignal = strainSignal(startStrain:endStrain);
A = (inflMat\strainSignal);


end

