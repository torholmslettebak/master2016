function [ InfluenceLines, influenceMatrix, C ] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors, samplePoints)
%   Calculates influence lines and stores them in matrices, 
format long;
[M, Amat, C] = findInfluenceLines(strainHistMat(:,1), TrainData);   %finds data from the strain signal from sensor 1
Infl=Amat\M;
% figure(2)
% plot(1:length(Infl), Infl)
% close(2)
InfluenceLines = zeros(length(Infl), numberOfSensors);  % initializes matrix to contain influence lines
InfluenceLines(:,1) = Infl; % fills column 1 with infl from above
inflMat =  genInflMatFromCalcInflLine( Infl, length(TrainData.axleWeights), C); % generates influence line matrix(later used to calc axle weights)
influenceMatrix = inflMat;  % Matrix which holds all inflMats, it now holds influence mat for 1 sensor/signal

for i = 2:numberOfSensors       %loops through strainhistmat to get data for each influence line
    [M, Amat, C] = findInfluenceLines(strainHistMat(:,i), TrainData);   % as on line 4 but for signal i (strainHistMat(:,i))
    Infl=Amat\M;    % as on line 5
    InfluenceLines(:,i) = Infl; % as on line 10
    inflMat =  genInflMatFromCalcInflLine( Infl, TrainData.axles, C); % generates inflMat for this spesific influence line
    influenceMatrix = [influenceMatrix inflMat];    % appends inflMat to influenceMatrix
end

end

