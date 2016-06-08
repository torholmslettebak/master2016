function [ InfluenceLines, influenceMatrix, x ] = inflMatrixMethod( strainHistMat, TrainData, sensorLocs, numberOfSensors, t, original, trainNumber)
%INFLMATRIXMETHOD Summary of this function goes here
%   Detailed explanation goes here
%             figure(3)
%             plot(t, strainHistMat(:,2));
%             hold on;
            [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
            numberOfSamplesWanted = length(strainHistMat(:,1))-C(length(C))-1;
%             deltaX = TrainData.bridge_L/numberOfSamplesWanted;
%             x = 0:deltaX:TrainData.bridge_L;
            dx = TrainData.delta * TrainData.speed;
            x = [0:numberOfSamplesWanted]*dx;
%             figure(2)
%             plot(x, InfluenceLines(:,1), x, InfluenceLines(:,2), x, InfluenceLines(:,3))
%             title('Calculated influence lines for Leirelva bridge')
%             legend('middleInfl', 'towardsTrondheimInfl', 'towardsHeimdalInfl')
            if trainNumber == 7
                Eps1 = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights);
                Eps2 = influenceMatrix(:,7:TrainData.axles*2)*transpose(TrainData.axleWeights);
                Eps3 = influenceMatrix(:,15:TrainData.axles*3)*transpose(TrainData.axleWeights);
            else
                Eps1 = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights);
                Eps2 = influenceMatrix(:,9:TrainData.axles*2)*transpose(TrainData.axleWeights);
                Eps3 = influenceMatrix(:,17:TrainData.axles*3)*transpose(TrainData.axleWeights);
            end
            
            
            
            figure(3)
            plot(1:length(original(:,1)), original(:,1),1:length(Eps1), Eps1)
            title('Strainhistory, calculated vs measured for middle sensor')
            legend('measured strain', 'recreated strain');
            xlabel('time [s]');
            ylabel('strain [\varepsilon]');
%             matlab2tikz('..\..\thesis\tikz\strain_recreated_train8_sensorMiddle.tex', 'height', '\figureheight', 'width', '\figurewidth');
            error1 = sum( (original(:,1) - Eps1).^2 );
            figure(4)
            plot(1:length(original(:,2)), original(:,2),1:length(original(:,2)), Eps2)
            title('Strainhistory, calculated vs measured for Trondheim sensor')
            legend('measured strain', 'recreated strain');
            xlabel('time [s]');
            ylabel('strain [\varepsilon]');
%             matlab2tikz('..\..\thesis\tikz\strain_recreated_train8_sensorTrondheim.tex', 'height', '\figureheight', 'width', '\figurewidth');
            error2 = sum( (original(:,2) - Eps2).^2 );
            figure(5)
            plot(1:length(original(:,3)), original(:,3),1:length(original(:,3)), Eps3)
            title('Strainhistory, calculated vs measured for Heimdal sensor')
            legend('measured strain', 'recreated strain');
            xlabel('time [s]'); 
            ylabel('strain [\varepsilon]');
%             matlab2tikz('..\..\thesis\tikz\strain_recreated_train8_sensorHeimdal.tex', 'height', '\figureheight', 'width', '\figurewidth');
            error3 = sum( (original(:,3) - Eps3).^2 );
            ERRORTABLE_ = [error1 error2 error3]
            originalSum = [sum( (original(:,1)).^2 ) sum( (original(:,2) ).^2 ) sum( (original(:,3) ).^2 )]
            errorPercentage = [ERRORTABLE_(1)*100/originalSum(1) ERRORTABLE_(2)*100/originalSum(2) ERRORTABLE_(3)*100/originalSum(3)]
end

