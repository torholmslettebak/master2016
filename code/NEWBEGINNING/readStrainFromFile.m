function [ t, delta_t, s1, s2, s3, M ] = readStrainFromFile( trainFileToRead, TrainData, sensorLocs)
%READSTRAINFROMFILE Summary of this function goes here
%   Detailed explanation goes here
format long;
path = '..\makeStrainHistory\train\';
files = dir('..\makeStrainHistory\train\*.txt');
addpath('..\makeStrainHistory\');
M = dlmread([path files(trainFileToRead).name],' ',3,0);
[startInd, endInd] = findStrainArea(M);
s2 = shiftVectorToZero(M(startInd:endInd, 3)); % towards TrondHeim Sensor
s3 = shiftVectorToZero(M(startInd:endInd, 4)); % Towards Heimdal Sensor
trainDirection = sign(speedByCorrelation(s2, s3, TrainData.time, 2, TrainData.delta)); % -1 <=> towards heimdal, 1 <=> towardsTrondheim
% figure(10)
% plot(M(:,1), M(:,2));
% % plot(t, s1)
% close(10)
if(trainDirection == -1) % Train goes towards heimdal
    %Append extra points more towards Trondheim than Heimdal
    [startInd, endInd] = findStrainArea(M);
    [samplesBefore, samplesAfter] = findNecessarySamples(TrainData, sensorLocs(1));
    s1 = shiftVectorToZero(M(startInd-1000:endInd+7000, 2)); % Midspan sensor
    [samplesBefore, samplesAfter] = findNecessarySamples(TrainData, sensorLocs(1));
    s2 = shiftVectorToZero(M(startInd-1000:endInd+7000, 3)); % towards TrondHeim Sensor
    [samplesBefore, samplesAfter] = findNecessarySamples(TrainData, sensorLocs(1));
    s3 = shiftVectorToZero(M(startInd-1000:endInd+7000, 4)); % Towards Heimdal Sensor
    t = M(startInd-1000:endInd+7000,1);
    delta_t = t(2)-t(1);
elseif trainDirection == 1 % Train goes towards Trondheim
%     Append extra points, more towards Heimdal than Trondheim
    [startInd, endInd] = findStrainArea(M);
    [samplesBefore, samplesAfter] = findNecessarySamples(TrainData, TrainData.bridge_L - sensorLocs(1));
    s1 = shiftVectorToZero(M(startInd-7000:endInd+1000, 2)); % Midspan sensor
    [samplesBefore, samplesAfter] = findNecessarySamples(TrainData, TrainData.bridge_L - sensorLocs(2));
    s2 = shiftVectorToZero(M(startInd-7000:endInd+1000, 3)); % towards TrondHeim Sensor
    [samplesBefore, samplesAfter] = findNecessarySamples(TrainData, TrainData.bridge_L - sensorLocs(3));
    s3 = shiftVectorToZero(M(startInd-7000:endInd+1000, 4)); % Towards Heimdal Sensor
    t = M(startInd-7000:endInd+1000,1);
    delta_t = t(2)-t(1);
else
    disp('the strainHistories are identical or nonexistant')
    return;
end 
% [startInd, endInd] = findStrainArea(M);
% s1 = shiftVectorToZero(M(startInd:endInd, 2)); % Midspan sensor
% s2 = shiftVectorToZero(M(startInd:endInd, 3)); % towards TrondHeim Sensor
% s3 = shiftVectorToZero(M(startInd:endInd, 4)); % Towards Heimdal Sensor
% t = M(startInd:endInd,1);
% delta_t = t(2)-t(1);
% figure(10)
% plot(t(startInd:endInd), s1(startInd:endInd));
% plot(t, s1)
% close(10)
end

