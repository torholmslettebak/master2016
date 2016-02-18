% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code
format long
clear; clc; clf;
% Lengt of bridge [m]
L = 20;
% Number of sensors
n = 2;
% Distance between sensors
% n_d = 5;
%number of axles
% n_a = 4;
%distanse between axles
d_a = 21;
% Distane from reaction A to first sensor
L_a = 10;
% Distance from reaction A to furthest sensor
L_b = 10;

axleWeights = [10000 10000];
axleDistances = [d_a];
% 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 0 0 0
numberOfAxles = length(axleWeights)
% disp(['number of axles ' num2str(numberOfAxles)])
TrainData = struct('weights', axleWeights, 'axles', numberOfAxles);
TrainData.weights;
% The speed [m/s]
v = 20;  % should use 30 seconds to pass the bridge
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);
delta_t = 0.01;
disp('time')
L+(numberOfAxles -1)*d_a/v
if(numberOfAxles > 1)
	t = 0:delta_t:( (L+(numberOfAxles-1)*d_a)/v);
else
	t = 0:delta_t:(L+1)/v;
end

[a,b,c,d] = generateInfluenceLine(L, L_a);
fillInfluenceLine(a, b, c, d, L_a, L);
ordinateMatrixTEST = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_a, d_a, axleDistances);

strainHist = calcStrainHist(ordinateMatrixTEST, axleWeights, E, Z);
figure; plot(t,strainHist);

% Add white gaussian noise to strain signal
y1 = awgn(strainHist, 100, 'measured');


hold on
[a,b,c,d] = generateInfluenceLine(L, L_b);
fillInfluenceLine(a, b, c, d, L_b, L);
ordinateMatrix2 = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_b, d_a, axleDistances);
strainHist2 = calcStrainHist(ordinateMatrix2, axleWeights, E, Z);
% figure; plot(t,strainHist2)
% Add white gaussian noise to strain signal
y2 = awgn(strainHist2, 51, 'measured');

calcSpeed = speedByCorrelation(strainHist, strainHist2,t, L_b - L_a, delta_t);
[calculatedAxleDistance, calculatedAxleDistances, locs] = axleDetection(strainHist, t, v); 
[a,b,c,d] = generateInfluenceLine(L, L_a);

testMatrix = createInfluenceMatrixFromStrain(t, v, L, a, b, c, d, L_a, calculatedAxleDistances);

A = E*Z*(testMatrix\strainHist);
figure(2)
plot(t, strainHist, t, strainHist2)
theTitle = ['Calculated strain history for ' num2str(numberOfAxles) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2')

