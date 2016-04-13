function [v, InfluenceLines, influenceMatrix, C, TrainData] = optimizeForSpeed( TrainData, strainHistMat, sensorLocs, numberOfSensors )
%OPTIMIZEFORSPEED Summary of this function goes here
%   Detailed explanation goes here

calculatedStrainHist  = @(v)setVelocityAndCalcStrain(TrainData, strainHistMat, sensorLocs, numberOfSensors,v);
TolFun = 0;
% options = optimset('TolFun', TolFun);
options = optimoptions('fmincon','TolX', 1e-3, 'TolFun', TolFun, 'TolCon', TolFun, 'Algorithm','sqp');
v1 = TrainData.speed;
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub =[];
nonlcon = [];
options
leastSquareFun = @(v)sum((strainHistMat(:,1) - calculatedStrainHist(v)).^2);
[v, fval] = fmincon(leastSquareFun, v1, A, b, Aeq, beq, lb,ub,nonlcon, options);

TrainData.speed = v;
[InfluenceLines, influenceMatrix, C] = influenceLineByMatrixMethod(TrainData, strainHistMat, sensorLocs, numberOfSensors);
end

