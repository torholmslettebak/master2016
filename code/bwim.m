% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code
format long
clear; clc; clf;
% Lengt of bridge [m]
L = 30;
% Number of sensors
n = 2;
% Distance between sensors
n_d = 5;
%number of axles
% n_a = 4;
%distanse between axles
d_a = 0.5;
% Distane from reaction A to first sensor
L_a = 15;
% Distance from reaction A to furthest sensor
L_b = 25;

axleWeights = [10000 100000 100000 100000 100000 100000 100000 100000 100000];
% 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 0 0 0
numberOfAxles = length(axleWeights);
% disp(['number of axles ' num2str(numberOfAxles)])
TrainData = struct('weights', axleWeights, 'axles', numberOfAxles);
TrainData.weights;
% The speed [m/s]
v = 1;  % should use 30 seconds to pass the bridge
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);
delta_t = 0.1;
if(numberOfAxles > 1)
	t = 0:delta_t:( (L+(numberOfAxles -1)*d_a)/v);
else
	t = 0:delta_t:(L+1)/v;
end
clf(1)
[a,b,c,d] = generateInfluenceLine(L, L_a);
fillInfluenceLine(a, b, c, d, L_a, L);
ordinateMatrix = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_a, d_a);

strainHist = calcStrainHist(ordinateMatrix, axleWeights, E, Z);
% Add white gaussian noise to strain signal
y1 = awgn(strainHist, 100, 'measured');


hold on
[a,b,c,d] = generateInfluenceLine(L, L_b);
fillInfluenceLine(a, b, c, d, L_b, L);
ordinateMatrix2 = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_b, d_a);
strainHist2 = calcStrainHist(ordinateMatrix2, axleWeights, E, Z);
% Add white gaussian noise to strain signal
y2 = awgn(strainHist2, 51, 'measured');

calcSpeed = speedByCorrelation(y1, y2,t, L_b - L_a, delta_t);
[calculatedAxleDistance, axleDistances, locs] = axleDetection(strainHist, t, v); % Supposed to calculate axle distances, so
% far not even close
[a,b,c,d] = generateInfluenceLine(L, L_a);
testMatrix = createInfluenceMatrixFromStrain(t, v, L, a, b, c, d, L_a, axleDistances);
A = inv(transpose(testMatrix)*(testMatrix))*(transpose(testMatrix) * strainHist);
figure(2)
plot(t, strainHist, t, strainHist2)
theTitle = ['Calculated strain history for ' num2str(numberOfAxles) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2')

