function [ speed ] = speedByPeaks( vector1, vector2, vector3, t, sensorLocations )
%SPEEDBYPEAKS Summary of this function goes here
%   Detailed explanation goes here

% filtered1 = denoiseSignal(vector1, 100);
filtered1 = fftFilter( vector1, 1, length(vector1), 5, 1024, 1:length(vector1)); 
filtered2 = fftFilter( vector2, 1, length(vector2), 5, 1024, 1:length(vector2)); 
filtered3 = fftFilter( vector3, 1, length(vector3), 5, 1024, 1:length(vector3)); 
% filtered2 = denoiseSignal(vector2, 100);
% filtered3 = denoiseSignal(vector3, 100);
[pks1, locs1] = findpeaks(filtered1,'SortStr','descend', 'MinPeakHeight',max(filtered1)/5);
figure(1)
plot(t,filtered1,t(locs1), filtered1(locs1),'o');
hold on;
[pks2, locs2] = findpeaks(filtered2,'SortStr','descend', 'MinPeakHeight',max(filtered2)/5);
figure(2)
plot(t,filtered2,t(locs2), filtered2(locs2),'o');
hold on;
[pks3, locs3] = findpeaks(filtered3,'SortStr','descend', 'MinPeakHeight', max(filtered3)/5);
figure(3)
plot(t,filtered3,t(locs3), filtered3(locs3),'o');

dist12 = abs(sensorLocations(1)-sensorLocations(2));
dist13 = abs(sensorLocations(1)-sensorLocations(3));
dist23 = abs(sensorLocations(2)-sensorLocations(3));
time12 = abs(t(locs1(1)) - t(locs2(1)));
time13 = abs(t(locs3(1)) - t(locs1(1)));
time23 = abs(t(locs3(1)) - t(locs2(1)));
v12 = dist12/time12;
v13 = dist13/time13;
v23 = dist23/time23;
vavg = (v12 + v13 + v23)/3
close(3);close(2);close(1);
end

