% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code
% format long
clear; clc; clf;
% Lengt of bridge [m]
L = 50;
% Distance from reaction A to first sensor
L_a = 25;
% Distance from reaction A to furthest sensor
L_b =26;
TrainData = makeTrain();
% TrainData.weights; Access trainData elements like this
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Bridge Data %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);
BridgeData = struct('Emod', E, 'SectionMod', Z);

delta_t = 0.001;
if length(TrainData.axleWeights) > 1
	t = 0:delta_t:( (L+sum(TrainData.axleDistances))/TrainData.speed);
else
	t = 0:delta_t:(L+1)/v;
end
[a,b,c,d] = generateInfluenceLine(L, L_a);
clf(1)
fillInfluenceLine(a, b, c, d, L_a, L);
ordinateMatrix = createInfluenceOrdinateMatrix(t, TrainData,L, a,b,c,d, L_a);

strainHist = calcStrainHist(ordinateMatrix, TrainData.axleWeights, E, Z);

% Add white gaussian noise to strain signal
y1 = awgn(strainHist, 140);
hold on
[a,b,c,d] = generateInfluenceLine(L, L_b);
fillInfluenceLine(a, b, c, d, L_b, L);
ordinateMatrix2 = createInfluenceOrdinateMatrix(t, TrainData,L, a,b,c,d, L_b);
strainHist2 = calcStrainHist(ordinateMatrix2, TrainData.axleWeights, E, Z);


% Add white gaussian noise to strain signal
y2 = awgn(strainHist2, 140);
calculatedSpeed = speedByCorrelation(y1, y2,t, L_b - L_a, delta_t);
[calculatedAxleDistances, locs] = axleDetection(strainHist, t, TrainData.speed);
[a,b,c,d] = generateInfluenceLine(L, L_a);

influenceMatrix = createInfluenceMatrixFromStrain(t, TrainData.speed, L, a, b, c, d, L_a, calculatedAxleDistances);

A = E*Z*(influenceMatrix\strainHist);
figure(4);
plot(t, strainHist, t, strainHist2);
theTitle = ['Calculated strain history for ' num2str(length(TrainData.axleWeights)) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2')

