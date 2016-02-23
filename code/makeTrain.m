function [ trainData ] = makeTrain( )
    %MAKETRAIN Creates struct containing data needed to create strainHistory
    %distanse between axles
    axleWeights = [60e3 80e3 60e3 80e3];
    axleDistances = [21 5 21];
    numberOfAxles = length(axleWeights);
    % The speed [m/s]
    v = 10;
    trainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v);
end

