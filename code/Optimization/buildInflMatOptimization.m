function [ inflMat, infl] = buildInflMatOptimization( strainHistory, TrainData, sensorLoc, h, type )
%BUILDINFLMATOPTIMIZATION This function should build an influence line
%based on the values given in h, which hold magnitude for different
%positions on the influence line.
h
C = axleDistancesInSamples(TrainData);
x= (1:length(strainHistory)-C(length(C)))*TrainData.delta*TrainData.speed;
x1 = x(x<=sensorLoc);
x2 = x(x>sensorLoc);

if ~isempty(type)
    if strcmp(type, 'linear')
        infl = buildLinearInfluenceLine(x, x1, x2, h, sensorLoc);
    elseif strcmp(type, 'polynomial')
        delta = x(2)-x(1);
        
        datapoints = 0:TrainData.bridge_L;
        indArr = splitArray(length(datapoints), length(h));
        data = zeros(1, length(indArr));
        for i = 2:length(indArr)
           data(i) = data(i-1)+indArr(i);
        end
        infl = buildPolyInfluenceLine(data, delta, h, TrainData);
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

