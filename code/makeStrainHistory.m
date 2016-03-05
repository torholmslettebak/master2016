function [ strainHist, original ] = makeStrainHistory( TrainData,sensorLoc, E, Z  )
%MAKESTRAINHISTORY Summary of this function goes here
%   Detailed explanation goes here
[a,b,c,d] = generateInfluenceLine(TrainData.bridge_L, sensorLoc);

fillInfluenceLine(a, b, c, d, sensorLoc, TrainData.bridge_L);
ordinateMatrix = createInfluenceOrdinateMatrix(TrainData, a,b,c,d, sensorLoc);

original = calcStrainHist(ordinateMatrix, TrainData.axleWeights, E, Z);
strainHist = awgn(original, 100);
hold on;
end

