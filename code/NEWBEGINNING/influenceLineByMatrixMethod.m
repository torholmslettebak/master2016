function [ InfluenceLines, influenceMatrix, C ] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors, samplePoints)
%   
format long;
[M, Amat, C] = findInfluenceLines(strainHistMat(:,1), TrainData);
Infl=Amat\M;
% figure(2)
% plot(1:length(Infl), Infl)
% close(2)
InfluenceLines = zeros(length(Infl), numberOfSensors);
InfluenceLines(:,1) = Infl;
inflMat =  genInflMatFromCalcInflLine( Infl, length(TrainData.axleWeights), C);
influenceMatrix = inflMat;

for i = 2:numberOfSensors
    [M, Amat, C] = findInfluenceLines(strainHistMat(:,i), TrainData);
    Infl=Amat\M;
    InfluenceLines(:,i) = Infl;
    inflMat =  genInflMatFromCalcInflLine( Infl, TrainData.axles, C);

%     influenceMatrix(:,(i-1)*(TrainData.axles)+1:i*(TrainData.axles)) = inflMat;
    influenceMatrix = [influenceMatrix inflMat];
end



end

