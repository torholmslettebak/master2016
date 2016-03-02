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
% E modulus N/m^2                                                         %
E = 200*10^9;                                                             %
% Section modulus (IPE 300 m^3)                                           %
Z = 3.14e5 / (1000^3);                                                    %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
clf(1);
strainHist = makeStrainHistory(TrainData, L_a, E, Z);
strainHistOriginal = strainHist; 
strainHist2 = makeStrainHistory(TrainData, L_b, E, Z);
noiseFrequency = findNoiseFrequency(strainHist, 1/TrainData.delta);
strainHist = denoiseSignal(strainHist, noiseFrequency);
strainHist2 = denoiseSignal(strainHist2, noiseFrequency);
calculatedSpeed = speedByCorrelation(strainHist, strainHist2, TrainData.time, L_b - L_a, TrainData.delta);
[calculatedAxleDistances, locs] = axleDetection(strainHist, TrainData.time, TrainData.speed);

influenceMatrix = createInfluenceMatrixFromStrain(L_a, calculatedAxleDistances, TrainData);

A = E*Z*(influenceMatrix\strainHist);

hold on;
[M, Amat] = findInfluenceLines( TrainData.axleWeights, strainHist, TrainData.axleDistances, TrainData.speed, TrainData.delta);
% [M, Amat] = findInfluenceLines( TrainData.axleWeights, strainHist, calculatedAxleDistances, TrainData.speed, TrainData.delta);
Infl=Amat\M;
noiseFrequency = findNoiseFrequency(Infl, 1/TrainData.delta);
Infl = denoiseSignal(Infl, noiseFrequency);
[M, Amat] = findInfluenceLines( TrainData.axleWeights, strainHist2, TrainData.axleDistances, TrainData.speed, TrainData.delta);
Infl2 = Amat\M;
Infl2 = denoiseSignal(Infl2, noiseFrequency);
figure(1);
x= (1:length(Infl))*TrainData.delta*TrainData.speed;
plot(x, Infl*E*Z, x, Infl2*E*Z)
legend('influence line sensor1','influence line sensor2',['calculated influence line by E*Z = ' num2str(E*Z)], ['calculated influence line num 2by E*Z = ' num2str(E*Z)]);
figure(4);
x= (1:length(Infl))*TrainData.delta;
figure(4);
plot(TrainData.time, (strainHist), TrainData.time, (strainHist2), x, Infl*Z/E, x, Infl2);
% plot(TrainData.time,strainHistOriginal, x, Infl*Z/E, x, Infl2);
theTitle = ['Calculated strain history for ' num2str(length(TrainData.axleWeights)) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2', 'infl1','infl2');
