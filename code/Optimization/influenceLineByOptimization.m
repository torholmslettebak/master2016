function [ influenceLine ] = influenceLineByOptimization( strainHistory, TrainData, sensorLoc, E, Z, type)
% THE FOLLOWING GENERATES A LINEAR INFLUENCE LINE FOR A SINGLE MAGNITUDE, only
% unknown for optimization is h - magnitudes of influence line
C = axleDistancesInSamples(TrainData);
x= (1:length(strainHistory)-C(length(C)))*TrainData.delta*TrainData.speed;
if ~isempty(type)
    if strcmp(type, 'linear')
%         h1= 0:TrainData.bridge_L;
        h1 = ones(1, TrainData.bridge_L);
        h1 = findInitialGuessValues(x, h1);
%         h1 = [h1 1];
        inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type));
    elseif strcmp(type, 'polynomial')
%         h1 = 0:TrainData.bridge_L;
        h1 = ones(1, TrainData.bridge_L);
        h1 = findInitialGuessValues(x, h1);
%         h1 = [h1 1];
        inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type));
    else
        %     No known type offered - > Do linear
%         h1= 0:TrainData.bridge_L;
        h1 = ones(1, TrainData.bridge_L);
        h1 = findInitialGuessValues(x, h1);
%         h1 = [h1 1];
        inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type));
    end
else
%     h1= 0:TrainData.bridge_L;
    h1 = ones(1, TrainData.bridge_L);
%     h1 = [h1 1];
    inflMat = @(h)(buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type));
end
% A = zeros(2,length(h1))
% A(1,1) = 1;
% A(1,length(h1)) = 1;
% A(2,length(h1)) = 1;
% A(2,1) = 1;
% b = [0; 0];

% CONSTRAINTS OF FMINCON
A = [];
b = [];
Aeq = [];
beq = [];
lb = zeros(1, length(h1));
lb(1,1) = 0;
lb(1,length(h1)) = 0;
% lb = [lb 0];
ub = inf(1, length(h1));
ub(1,1) = 0;
ub(1,length(h1)) = 0;
% ub = [ub inf];
% EZ = 100000;
% h1 = [h1 EZ];
opts = optimoptions('fminunc','Algorithm','quasi-newton');

% leastSquareFun = @(h)sum((strainHistory - (1/h(length(h1))*(inflMat(h(1:length(h1)-1))*transpose(TrainData.axleWeights)))).^2);
h1
leastSquareFun = @(h)sum((strainHistory - (1/(E*Z))*((inflMat(h)*transpose(TrainData.axleWeights)))).^2);
% [h, fval] = fminunc(leastSquareFun, h1, opts);
[h, fval] = fmincon(leastSquareFun, h1, A, b, Aeq, beq, lb, ub);
h
[~, influenceLine] = (inflMat(h));
% ez = h(length(h1))
end

