function [ strainHist, originalWONoiseOrDynamics ] = makeStrainHistory( TrainData,sensorLoc, E, Z  )
%MAKESTRAINHISTORY Summary of this function goes here
%   Detailed explanation goes here
[a,b,c,d] = generateInfluenceLine(TrainData.bridge_L, sensorLoc);

fillInfluenceLine(a, b, c, d, sensorLoc, TrainData.bridge_L);
ordinateMatrix = createInfluenceOrdinateMatrix(TrainData, a,b,c,d, sensorLoc);
% figure(11)
% plot(1:length(ordinateMatrix(:,1)), ordinateMatrix(:,1));
% close(11)
originalWONoiseOrDynamics = calcStrainHist(ordinateMatrix, TrainData.axleWeights, E, Z);
length(originalWONoiseOrDynamics)
% figure(11)
% plot(1:length(originalWONoiseOrDynamics), originalWONoiseOrDynamics);
% close(11)
dynamics = sin(pi^2*originalWONoiseOrDynamics/TrainData.bridge_L^2);
% dynamics = 0;
strainHist = awgn(originalWONoiseOrDynamics+ dynamics, 100);
% strainHist = originalWONoiseOrDynamics;
% figure(11)
% plot(1:length(strainHist), strainHist);
% close(11)
end

