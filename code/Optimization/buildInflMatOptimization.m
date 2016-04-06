function [ inflMat, infl] = buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type, indexVec )
%BUILDINFLMATOPTIMIZATION This function should build an influence line
%based on the values given in h, which hold magnitude for different
%positions on the influence line.
% h
C = axleDistancesInSamples(TrainData);
% x= (1:length(strainHistory)-C(length(C)))*TrainData.delta*TrainData.speed;
% x= (1:length(strainHistory)-C(length(C)))*TrainData.delta*TrainData.speed
% - TrainData.delta*TrainData.speed; Possible alternative version, to get x
% to start at zero....
x = 0:TrainData.delta*TrainData.speed:TrainData.bridge_L;
x1 = x(x<=sensorLoc);
x2 = x(x>sensorLoc);

if ~isempty(type)
    if strcmp(type, 'linear')
        infl = buildLinearInfluenceLine(x, x1, x2, h, sensorLoc);
    elseif strcmp(type, 'polynomial')
        delta = x(2)-x(1);
        
%         datapoints = length(x);
        
%         indArr = splitArray(length(datapoints), length(h));
        data = zeros(1, length(h));
        for i = 1:length(h)
           data(i) = x(indexVec(i));
        end
        infl = buildPolyInfluenceLine(data, delta, h, TrainData);
        figure(12)
        plot(x,infl);
        close(12);
    else
        %     No type offered - > Do linear
       
    end
else
  infl = buildLinearInfluenceLine(x, x1, x2, h, sensorLoc);
end

inflMat = genInflMatFromCalcInflLine(infl, TrainData.axles, C);
plot(x,infl)
hold on;
end

