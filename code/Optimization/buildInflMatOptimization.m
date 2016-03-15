function [ inflMat, infl] = buildInflMatOptimization( strainHistory, TrainData, SensorData,h )
%BUILDINFLMATOPTIMIZATION This function should build an influence line
%based on the values given in h, which hold magnitude for different
%positions on the influence line.
% disp('the h vector ');
h = [h 0];
%   Detailed explanation goes here
L_a = SensorData.sensorA_loc;
delta = (TrainData.bridge_L+sum(TrainData.axleDistances))/(length(strainHistory));
x1 = 0:delta:L_a;
x2 = L_a+delta:delta:TrainData.bridge_L;
x = [x1,x2];
if length(h)==1
    infl1 = (h/L_a)*x1;
    infl2 = h - (h/L_a)*(x2-L_a);
    infl = [infl1, infl2];
elseif length(h)>1
    % The distance between data points
    dist = (length(x)/(length(h)));
    infl(1:round(dist)) = (h(1)/x(round(dist)))*x(1:round(dist));
    index = dist;
    for i = 2:length(h)
        infl(round(index):round(index+dist)) = h(i-1) + (((h(i)-h(i-1))/x(round(dist))))*(x(round(index):round(index+dist))-x(round(dist)*(i-1)));
        index = index + dist;
    end
else
    disp('Not enough parameters');
    return;
end
C = axleDistancesInSamples(TrainData);
inflMat = genInflMatFromCalcInflLine(infl, TrainData.axles, C);

% size(inflMat);
% length(x)
% length(infl)
figure(8)
% clf(8)
plot(x,infl)
hold on;
end

