function [  ] = readStrain(  )

%READSTRAIN Summary of this function goes here
%   Detailed explanation goes here
% 1603161026.txt
% load('makeStrainHistory\train\1603161026.txt')
format long;
addpath('filtering');
path = 'makeStrainHistory\train\';
files = dir('makeStrainHistory\train\*.txt');
M = dlmread([path files(3).name],' ',2,0);
t = M(:,1);
s1 = M(:,2);
delta_t = t(2)-t(1);
freq = findNoiseFrequency(s1(1:100), delta_t);
denoisedS1 = denoiseSignal(s1, freq*1000);
[startInd, endInd] = findStrainArea(M);
s1 = M(startInd:endInd, 2);
s2 = M(startInd:endInd, 3);
s3 = M(startInd:endInd, 4);
% disp('done1')
% [s2fixed, beginning2, ending2] = findStrainArea(s2, t);
% disp('done2')
% [s3fixed, beginning3, ending3] = findStrainArea(s3, t);
% disp('done3')
% beginning = [beginning1 beginning2 beginning3];
% ending = [ending1 ending2 ending3];
% minBegin = min(beginning);
% maxEnding = max(ending);
% LerdalsData= struct('L', 4.17, 'sensorLoc1', 4.17/2, 'sensorLoc2', (4.17/2)+1, 'sensorLoc3', (4.17/2)-1);
% Shifting values of strain to start at zero
s1 = shiftVectorToZero(s1);
s2 = shiftVectorToZero(s2);
s3 = shiftVectorToZero(s3);
%
figure(1)
% plot(t, s1, t, s2, t, s3, t(beginning1:ending1), s1fixed, '.', t(beginning2:ending2), s2fixed, '.', t(beginning3:ending3), s3fixed, '.')
plot(t(startInd:endInd), s1, t(startInd:endInd), s2, t(startInd:endInd), s3)
legend('Sensor1', 'Sensor2','Sensor3');
addpath('Optimization\');
% Axle distances based on drawing of NSB 92 train
axleDistances = [2.5 14 2.5 5.125 2.55 13.975 2.5];
numberOfAxles = 8;
L = 4.17;
% L = 10;
calculatedSpeed = speedByCorrelation(s1, s2, t(startInd:endInd), 1, delta_t);
% v = calculatedSpeed;
v = 23;
axleWeights = ones(1, numberOfAxles) * 10000;
TrainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v, 'delta', delta_t, 'time', t, 'bridge_L', L);
E = 1; Z = 1;
[calculatedAxleDistances, locs] = axleDetection(denoiseSignal(s1, 49), TrainData.time(startInd:endInd), TrainData.speed);
type = 'polynomial';
sumDist = sum(calculatedAxleDistances);
sumActualDist = sum(axleDistances);
% type = 'linear';
test = influenceLineByOptimization(s1, TrainData, 4.17/2, E, Z, type);
% test2 = Copy_of_buildInflMatOptimization(s1, TrainData, 4.17/2, E, Z, type);
x= (1:length(test))*TrainData.delta*TrainData.speed;
figure(3)
plot(x, test)
end

