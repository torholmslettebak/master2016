clear; clc; clf;
load('bwim_staged')
l = length(strain_data);

given_t = strain_data(:,1);
timestep = (given_t(2) - given_t(1));
% 
s1 = strain_data(:,2);
s2 = strain_data(:,3);
sd1 = denoiseSignal(s1);
sd2 = denoiseSignal(s2);
actual_axle_distances = zeros(1,length(axle_distances)-1);
for i = 2:length(axle_distances)
   actual_axle_distances(1,i-1) = axle_distances(i)-axle_distances(i-1); 
end
calculatedSpeed = speedByCorrelation(sd1, sd2, given_t, 1, timestep);
% calculatedSpeed = 3.5;
[calculatedAxleDistances, locs ] = axleDetection(sd1, given_t, calculatedSpeed);
% [M, Amat] = findInfluenceLines(axleWeigths, sd1, calculatedAxleDistances, calculatedSpeed, timestep);

figure(7)
plot(given_t, sd1, given_t, sd2);
title('filtered strain');
xlabel('time [s]');
ylabel('Strain');
legend('filtered1', 'filtered2');

figure(8)
plot(given_t, s1, given_t, s2);
title('unfiltered strain');
xlabel('time [s]');
ylabel('Strain');
legend('unfiltered1', 'unfiltered2');
