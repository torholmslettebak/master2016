function [ trainData ] = makeTrain( )
    %MAKETRAIN Creates struct containing data needed to create strainHistory
    %distanse between axles
    axleWeights = [10000 10000 10000 10000 10000 10000];
    axleDistances = [2 1 3 4 1];
    numberOfAxles = length(axleWeights);
    % The speed [m/s]
    v = 20;
    trainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v);
end

