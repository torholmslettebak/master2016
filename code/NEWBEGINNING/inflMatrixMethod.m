function [ InfluenceLines, influenceMatrix, x ] = inflMatrixMethod( strainHistMat, TrainData, sensorLocs, numberOfSensors, t)
%INFLMATRIXMETHOD Summary of this function goes here
%   Detailed explanation goes here
            figure(3)
            plot(t, strainHistMat(:,2));
            hold on;
            [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
            numberOfSamplesWanted = length(strainHistMat(:,1))-C(length(C))-1;
            deltaX = TrainData.bridge_L/numberOfSamplesWanted;
            x = 0:deltaX:TrainData.bridge_L;
            figure(2)
            plot(x, InfluenceLines(:,1), x, InfluenceLines(:,2), x, InfluenceLines(:,3))
            title('Calculated influence lines for Leirelva bridge')
            legend('middleInfl', 'towardsTrondheimInfl', 'towardsHeimdalInfl')
            Eps1 = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights);
            Eps2 = influenceMatrix(:,9:TrainData.axles*2)*transpose(TrainData.axleWeights);
            Eps3 = influenceMatrix(:,17:TrainData.axles*3)*transpose(TrainData.axleWeights);
            figure(3)
            plot(t, Eps1, t, Eps2, t, Eps3)
            title('Strainhistory, calculated vs measured')
            legend('measured strain', 'calculated middleSensor', 'calculated trondheimSensor', 'calculated heimdalSensor');
            
end

