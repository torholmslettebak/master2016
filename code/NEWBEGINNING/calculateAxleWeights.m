function [ calculatedWeights ] = calculateAxleWeights( averaged, xvec, strainHistMat, TrainData, sensorLocs, sensor, calculatedWeights, columnIndex )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
disp(['sensorLoc = ' num2str(sensorLocs(sensor))]);
xvec = removeZeroIndexesFromEnd(xvec);
averaged = removeZeroIndexesFromEnd(averaged);
C = axleDistancesInSamples(TrainData);
before = length(xvec(xvec<=sensorLocs(sensor)));
after = length(xvec(xvec>sensorLocs(sensor)));
xvec(before)
% figure(5)
% clf(5)
% plot(xvec, averaged, xvec(before), averaged(before), 'o');
% close(5)
% The first maximum peak of the strain signal should coincide with
% sensorLoc -> same length before sensorLoc as before
inflMat =  genInflMatFromCalcInflLine( averaged, length(TrainData.axleWeights), C);
[startStrain, endStrain, strainSignal] = fitStrainToInfl(strainHistMat(:,sensor), inflMat, averaged, C, before, after);
% strainSignal = strainHistMat(:,sensor);
strainSignal = strainSignal(startStrain:endStrain);
A = (inflMat\strainSignal);
A = round(A);
trainGrossWeight = round(sum(A));
% Train 3 4 5 6 8
carriage = round(sum(A(1:4)));
locomotive = round(sum(A(5:8)));
calculatedWeights(1:4,columnIndex) = A(1:4);
calculatedWeights(5, columnIndex) = carriage;
calculatedWeights(6:9,columnIndex) = A(5:8);
calculatedWeights(10, columnIndex) = locomotive;
calculatedWeights(11, columnIndex) = trainGrossWeight;

% train 7
% carriage = round(sum(A(1:4)));
% locomotive = round(sum(A(5:8)));
% calculatedWeights(1:4,columnIndex) = A(1:4);
% calculatedWeights(5, columnIndex) = carriage;
% calculatedWeights(6:9,columnIndex) = A(5:8);
% calculatedWeights(10, columnIndex) = locomotive;
% calculatedWeights(11, columnIndex) = trainGrossWeight;

end
