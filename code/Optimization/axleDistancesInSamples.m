function [ C ] = axleDistancesInSamples(TrainData)
% Calculates axle distances in samples from given speed of the train and
% the system's sampling frequency
n = length(TrainData.axleWeights);
C = zeros(1,n);
C(1) = 0;
frequency = 1/TrainData.delta;
for i = 1:n-1
        C(i+1) = round((sum(TrainData.axleDistances(1:i)))*frequency/TrainData.speed);
%         C(i+1) = round((sum(TrainData.axleDistances(1:i)))*(1/TrainData.delta)/TrainData.speed);
end
end

