% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code
% format long
clear; clc; clf;
% Lengt of bridge [m]
L = 20;
% Number of sensors
% n = 2;
%distanse between axles
d_a = 1;
% Distane from reaction A to first sensor
L_a = 10;
% Distance from reaction A to furthest sensor
L_b =15;

axleWeights = [10000 10000 10000 10000 10000 10000];
axleDistances = [2 1 3 4 1];
% 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 0 0 0
numberOfAxles = length(axleWeights)
numberOfAxleDistances = length(axleDistances)
% The speed [m/s]
v = 20;
TrainData = struct('weights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v);
% TrainData.weights; Access trainData elements like this
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Bridge Data %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);
BridgeData = struct('Emodulus', E, 'SectionModulus', Z);

delta_t = 0.001;
if(numberOfAxles > 1)
	t = 0:delta_t:( (L+(numberOfAxles-1)*d_a)/v);
else
	t = 0:delta_t:(L+1)/v;
end
clf(1);
[a,b,c,d] = generateInfluenceLine(L, L_a);
fillInfluenceLine(a, b, c, d, L_a, L);
ordinateMatrixTEST = createInfluenceOrdinateMatrix(t, v, L, a, b, c, d, L_a, axleDistances);

strainHist = calcStrainHist(ordinateMatrixTEST, axleWeights, E, Z);
% figure; plot(t,strainHist);

% Add white gaussian noise to strain signal
y1 = awgn(strainHist, 100, 'measured');


hold on
[a,b,c,d] = generateInfluenceLine(L, L_b);
fillInfluenceLine(a, b, c, d, L_b, L);
ordinateMatrix2 = createInfluenceOrdinateMatrix(t, v, L, a, b, c, d, L_b, axleDistances);
strainHist2 = calcStrainHist(ordinateMatrix2, axleWeights, E, Z);

% Add white gaussian noise to strain signal
y2 = awgn(strainHist2, 51, 'measured');
figure(4);
calcSpeed = speedByCorrelation(strainHist, strainHist2,t, L_b - L_a, delta_t);
[calculatedAxleDistance, calculatedAxleDistances, locs] = axleDetection(strainHist, t, v); 
[a,b,c,d] = generateInfluenceLine(L, L_a);

testMatrix = createInfluenceMatrixFromStrain(t, v, L, a, b, c, d, L_a, calculatedAxleDistances);

A = E*Z*(testMatrix\strainHist);
figure(2)
plot(t, strainHist, t, strainHist2, t, fliplr(strainHist))
theTitle = ['Calculated strain history for ' num2str(numberOfAxles) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2','flipped history')

