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
calculatedSpeed = speedByCorrelation(s1, s2, given_t, 1, timestep);
[calculatedAxleDistances, locs ] = axleDetection(sd1, given_t, calculatedSpeed);
% mdl = fitlm(given_t,sd1,'linear')
% plotResiduals(mdl,'probability')
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
