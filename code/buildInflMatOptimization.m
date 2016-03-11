function [ inflMat, infl ] = buildInflMatOptimization( strainHistory, TrainData, SensorData,h )
%BUILDINFLMATOPTIMIZATION Summary of this function goes here
%   Detailed explanation goes here
L_a = SensorData.sensorA_loc;
delta = (TrainData.bridge_L+sum(TrainData.axleDistances))/(length(strainHistory))
x1 = 0:delta:L_a;
x2 = L_a+delta:delta:TrainData.bridge_L;
infl1 = (h/L_a)*x1;
infl2 = h - (h/L_a)*(x2-L_a);
x = [x1,x2];
infl = [infl1, infl2];
length(infl)
C = axleDistancesInSamples(TrainData);
inflMat = genInflMatFromCalcInflLine(infl, TrainData.axles, C);
size(inflMat)
figure(8)
plot(x,infl)
hold on;
end

