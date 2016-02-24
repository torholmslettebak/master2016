% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code
% format long
clear; clc; clf;
% Lengt of bridge [m]
L = 40;
% Distance from reaction A to first sensor
L_a = 19;
% Distance from reaction A to furthest sensor
L_b =20;
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

% delta_t = 0.001;
% if length(TrainData.axleWeights) > 1
% 	t = 0:delta_t:( (L+sum(TrainData.axleDistances))/TrainData.speed);
% else
% 	t = 0:delta_t:(L+1)/v;
% end
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

