% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code
format long
clear; clc; clf;
% Lengt of bridge [m]
L = 10;
% Number of sensors
n = 2;
% Distance between sensors
n_d = 5;
%number of axles
% n_a = 4;
%distanse between axles
d_a = 1;
% Distane from reaction A to first sensor
L_a = 4;
% Distance from reaction A to furthest sensor
L_b = 6;

axleWeights = [1000 1000 1000];
numberOfAxles = length(axleWeights);
TrainData = struct('weights', axleWeights, 'axles', numberOfAxles);
TrainData.weights
% The speed [m/s]
v = 1;  % should use 30 seconds to pass the bridge
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);

if(numberOfAxles > 1)
	t = 0:0.01:( (L+(numberOfAxles -1)*d_a)/v);
else
	t = 0:0.01:(L+1)/v;
end
clf(1)
[a,b,c,d] = generateInfluenceLine(L, L_a);
fillInfluenceLine(a, b, c, d, L_a, L);
ordinateMatrix = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_a, d_a);

strainHist = calcStrainHist(ordinateMatrix, axleWeights, E, Z);
% Add white gaussian noise to strain signal
y1 = awgn(strainHist, 51, 'measured');


hold on
[a,b,c,d] = generateInfluenceLine(L, L_b);
fillInfluenceLine(a, b, c, d, L_b, L);
ordinateMatrix2 = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_b, d_a);
strainHist2 = calcStrainHist(ordinateMatrix2, axleWeights, E, Z);
% Add white gaussian noise to strain signal
y2 = awgn(strainHist2, 51, 'measured');

speedByCorrelation(y1, y2,t, L_b - L_a);
% axleDetection(strainHist, t) % Supposed to calculate axle distances, so
% far not even close
figure(2)
plot(t, y1, t, y2)
theTitle = ['Calculated strain history for ' num2str(numberOfAxles) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2')

