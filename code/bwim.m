% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code
% format long
clear; clc; clf;
% Distance from reaction A to first sensor
L_a = 10;
% Distance from reaction A to furthest sensor
L_b =11;
TrainData = makeTrain();

% Bridge Data %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);
E*Z
BridgeData = struct('Emod', E, 'SectionMod', Z);

[a,b,c,d] = generateInfluenceLine(TrainData.bridge_L, L_a);
clf(1)
fillInfluenceLine(a, b, c, d, L_a, TrainData.bridge_L);
ordinateMatrix = createInfluenceOrdinateMatrix(TrainData, a,b,c,d, L_a);

strainHist = calcStrainHist(ordinateMatrix, TrainData.axleWeights, E, Z);

% Add white gaussian noise to strain signal
y1 = awgn(strainHist, 140);
hold on
[a,b,c,d] = generateInfluenceLine(TrainData.bridge_L, L_b);
fillInfluenceLine(a, b, c, d, L_b, TrainData.bridge_L);
ordinateMatrix2 = createInfluenceOrdinateMatrix(TrainData, a, b, c, d, L_b);
strainHist2 = calcStrainHist(ordinateMatrix2, TrainData.axleWeights, E, Z);


% Add white gaussian noise to strain signal
y2 = awgn(strainHist2, 140);
calculatedSpeed = speedByCorrelation(y1, y2,TrainData.time, L_b - L_a, TrainData.delta);
[calculatedAxleDistances, locs] = axleDetection(strainHist, TrainData.time, TrainData.speed);
[a,b,c,d] = generateInfluenceLine(TrainData.bridge_L, L_a);

influenceMatrix = createInfluenceMatrixFromStrain(TrainData.time, TrainData.speed, TrainData.bridge_L, a, b, c, d, L_a, calculatedAxleDistances);

A = E*Z*(influenceMatrix\strainHist);
figure(4);
plot(TrainData.time, strainHist, TrainData.time, strainHist2);
theTitle = ['Calculated strain history for ' num2str(length(TrainData.axleWeights)) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2')
% [M, Amat] = findInfluenceLines( TrainData.axleWeights, strainHist, TrainData.axleDistances, TrainData.speed, TrainData.delta);
[M, Amat] = findInfluenceLines( TrainData.axleWeights, strainHist, calculatedAxleDistances, calculatedSpeed, TrainData.delta);
Infl=Amat\M;
figure(1);
x= (1:length(Infl))*TrainData.delta*TrainData.speed;
plot(x, Infl*E*Z)
legend('influence line sensor1','influence line sensor2',['calculated influence line by E*Z = ' num2str(E*Z)])
