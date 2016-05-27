function [ speed ] = findApproxSpeed( TrainData, strainHistMat, sensorLocs, numberOfSensors )
%FINDAPPROXSPEED Summary of this function goes here
%   Detailed explanation goes here



    x0 = 20;
    TrainData = makeTrain(x0);    
%     Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights); 
    
%     error = sum((strainHistMat(:,1) - Eps).^2);
    produceStrain = @(x)speedOptHelpFun(x, strainHistMat, sensorLocs, numberOfSensors));
    A = [];
    b = [];
    fun = @(x) sum((strainHistMat(:,1) - produceStrain(x)).^2);
    [x] = fmincon(fun, x0, A, b)
    
    
    
%     
%     format long;
% currentSpeed = 20;
% bestCaseSpeed = 0;
% bestError = Inf;
% delta = 1;
% speedVec = currentSpeed-5:delta:currentSpeed+5;
% for i = speedVec
%     i
%     TrainData = makeTrain(i);
%     [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
%     Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights); 
%     error = sum((strainHistMat(:,1) - Eps).^2);
%     if error < bestError
%         bestError = error;
%         bestCaseSpeed = i;
%     end
% end
% delta = 0.1;
% speedVec = bestCaseSpeed-0.5:delta:bestCaseSpeed+0.5;
% for i = speedVec
%     i
%     TrainData = makeTrain(i);
%     [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
%     Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights); 
%     error = sum((strainHistMat(:,1) - Eps).^2);
%     if error < bestError
%         bestError = error;
%         bestCaseSpeed = i;
%     end
% end
% delta = 0.01;
% speedVec = bestCaseSpeed-0.09:delta:bestCaseSpeed+0.09;
% for i = speedVec
%     i
%     TrainData = makeTrain(i);
%     [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
%     Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights); 
%     error = sum((strainHistMat(:,1) - Eps).^2);
%     if error < bestError
%         bestError = error;
%         bestCaseSpeed = i;
%     end
% end
% delta = 0.001;
% speedVec = bestCaseSpeed-0.009:delta:bestCaseSpeed+0.009;
% for i = speedVec
%     i
%     TrainData = makeTrain(i);
%     [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
%     Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights); 
%     error = sum((strainHistMat(:,1) - Eps).^2);
%     if error < bestError
%         bestError = error;
%         bestCaseSpeed = i;
%     end
% end
% delta = 0.0001;
% speedVec = bestCaseSpeed-0.001:delta:bestCaseSpeed+0.001;
% for i = speedVec
%     i
%     TrainData = makeTrain(i);
%     [InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
%     Eps = influenceMatrix(:,1:TrainData.axles)*transpose(TrainData.axleWeights); 
%     error = sum((strainHistMat(:,1) - Eps).^2);
%     if error < bestError
%         bestError = error;
%         bestCaseSpeed = i;
%     end
% end
% speed = bestCaseSpeed;
end

