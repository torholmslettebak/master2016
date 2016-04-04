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
s2 = M(:,3);
s3 = M(:,4);
delta_t = t(2)-t(1);
freq = findNoiseFrequency(s1(1:100), delta_t);
denoisedS1 = denoiseSignal(s1, freq*1000);
[s1fixed, beginning1, ending1] = findStrainArea(s1, t);
disp('done1')
[s2fixed, beginning2, ending2] = findStrainArea(s2, t);
disp('done2')
[s3fixed, beginning3, ending3] = findStrainArea(s3, t);
disp('done3')
figure(1)
plot(t, s1, t, s2, t, s3, t(beginning1:ending1), s1fixed, '.', t(beginning2:ending2), s2fixed, '.', t(beginning3:ending3), s3fixed, '.')
legend('Sensor1', 'Sensor2','Sensor3', 'cutout');



end

