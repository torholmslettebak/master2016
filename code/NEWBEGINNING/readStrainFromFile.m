function [ t, delta_t, s1, s2, s3, M ] = readStrainFromFile( trainFileToRead)
%READSTRAINFROMFILE Summary of this function goes here
%   Detailed explanation goes here
format long;
path = '..\makeStrainHistory\train\';
files = dir('..\makeStrainHistory\train\*.txt');
addpath('..\makeStrainHistory\');
M = dlmread([path files(trainFileToRead).name],' ',3,0);
% figure(10)
% plot(M(:,1), M(:,2));
% % plot(t, s1)
% close(10)
[startInd, endInd] = findStrainArea(M);
s1 = shiftVectorToZero(M(startInd:endInd, 2)); % Midspan sensor
s2 = shiftVectorToZero(M(startInd:endInd, 3)); % towards TrondHeim Sensor
s3 = shiftVectorToZero(M(startInd:endInd, 4)); % Towards Heimdal Sensor
t = M(startInd:endInd,1);
delta_t = t(2)-t(1);
% figure(10)
% plot(t(startInd:endInd), s1(startInd:endInd));
% plot(t, s1)
% close(10)
end

