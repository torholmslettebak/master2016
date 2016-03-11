function [ C ] = axleDistancesInSamples(TrainData)
%AXLEDISTANCESINSAMPLES Summary of this function goes here
%   Detailed explanation goes here
C = zeros(1,n);
C(1) = 0;
for i = 1:n-1
        C(i+1) = round((sum(TrainData.axleDistances(1:i)))*(1/TrainData.delta)/TrainData.speed);
end
end

