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
% noTrainHistory = bridgeWithoutTrain(TrainData.time);
% actualNoiseFreq = findNoiseFrequency(noTrainHistory, 1/TrainData.delta)
% denoisedNoTrain = denoiseSignal(noTrainHistory, actualNoiseFreq);
% figure(5);
% plot(TrainData.time, denoisedNoTrain);

clf(1);
[strainHist, original1] = makeStrainHistory(TrainData, L_a, E, Z);
strainHistOriginal = strainHist; 
[strainHist2, original2] = makeStrainHistory(TrainData, L_b, E, Z);
noiseFrequency = findNoiseFrequency(strainHist(1:100), 1/TrainData.delta);
strainHist = denoiseSignal(strainHist, noiseFrequency);
strainHist2 = denoiseSignal(strainHist2, noiseFrequency);
calculatedSpeed = speedByCorrelation(strainHist, strainHist2, TrainData.time, L_b - L_a, TrainData.delta);
[calculatedAxleDistances, locs] = axleDetection(strainHist, TrainData.time, TrainData.speed);
influenceMatrix = createInfluenceMatrixFromStrain(L_a, calculatedAxleDistances, TrainData);

A = E*Z*(influenceMatrix\strainHist);

hold on;
[M, Amat, C1] = findInfluenceLines( TrainData.axleWeights, strainHist, TrainData.axleDistances, TrainData.speed, TrainData.delta);
% [M, Amat] = findInfluenceLines( TrainData.axleWeights, strainHist, calculatedAxleDistances, TrainData.speed, TrainData.delta);
Infl=Amat\M;
% noiseFrequency = findNoiseFrequency(Infl, 1/TrainData.delta);
Infl = denoiseSignal(Infl, noiseFrequency);
[M, Amat, C2] = findInfluenceLines( TrainData.axleWeights, strainHist2, TrainData.axleDistances, TrainData.speed, TrainData.delta);
Infl2 = Amat\M;
Infl2 = denoiseSignal(Infl2, noiseFrequency);
% axleWeights = E*Z*()
figure(1);
x= (1:length(Infl))*TrainData.delta*TrainData.speed;
plot(x, Infl*E*Z, x, Infl2*E*Z)
legend('influence line sensor1','influence line sensor2',['calculated influence line by E*Z = ' num2str(E*Z)], ['calculated influence line num 2by E*Z = ' num2str(E*Z)]);
% avgfilt = moving_average(strainHistOriginal, 1,1);
% for i = 1:5000
%     avgfilt = moving_average(avgfilt, 1,1);
% end
% [calculatedAxleDistances, locs] = axleDetection(avgfilt, TrainData.time, TrainData.speed);
% avgfilt = denoiseSignal(avgfilt, noiseFrequency*50);
figure(4);
x= (1:length(Infl))*TrainData.delta;
figure(4);
plot(TrainData.time, (strainHist), TrainData.time, (strainHist2),TrainData.time, original1)

% plot(TrainData.time,strainHistOriginal, x, Infl*Z/E, x, Infl2);
title(['Calculated strain history for ' num2str(length(TrainData.axleWeights)) ' train axles']);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2','original without noise');
newInfluenceMatrix = genInflMatFromCalcInflLine(E*Z*Infl, TrainData.axles, C1);


% TODO ????
% Create "perfect" influence line for a given strain history
% where the properties of the train are given (axle spacing, axle weights,
% train speed osv)
% The location of strain sensor is also known..

% SO far this code finds a decent approximization of the theoretical
% influence lines. It starts with a too high value, and accumulates more
% error for each axle added to the bridge. This error comes from smoothing
% of the noisy strain signal which results in a loss of edges in the
% signal. This leads to a too curvy signal. The result of this can easily
% be seen when studying the extremal points of the influence line, the
% beginning, maximum and the end.

% There is a possibility that it is possible to improve the results from 
% the matrix method by constraining the influence line from the known values. 

% Add simple dynamics to the model.. only one or two sine waves to distort
% signal

% Optimization
% fminuc
% interpolating a polynomial

% TODO - OPTIMIZATION
% How ?
% we have a strain signal and the vehicle properties
% And we have an idea of how the influence line is supposed to be
% Through the fminuc function and the desired properties of the influence
% line, the best case influence line can be calculated.. The function does
% this by comparing given strain signal with calculated strain signal 
% this is done through: 
% sum(signal-generated_signal)^2
% the properties of the influence line which minimizes this gives us the
% best result. SEE NOTES FROM DANIEL FOR MORE VISUAL INFORMATION.




