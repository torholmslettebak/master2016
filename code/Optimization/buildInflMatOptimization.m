function [ inflMat, infl] = buildInflMatOptimization( strainHistory, TrainData, sensorLoc,h )
%BUILDINFLMATOPTIMIZATION This function should build an influence line
%based on the values given in h, which hold magnitude for different
%positions on the influence line.
% disp('the h vector ');
h = [h 0];
%   Detailed explanation goes here
% L_a = 0;
% if(sensornum==1)

% else
%     L_a = SensorData.sensorB_loc;
% end
delta = (TrainData.bridge_L+sum(TrainData.axleDistances))/(length(strainHistory));
x1 = 0:delta:sensorLoc;
x2 = sensorLoc+delta:delta:TrainData.bridge_L;
x = [x1,x2];
if length(h)==1
    infl1 = (h/sensorLoc)*x1;
    infl2 = h - (h/sensorLoc)*(x2-sensorLoc);
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
% clf(8)
plot(x,infl)
hold on;
end

