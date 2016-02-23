function [ trainData ] = makeTrain( )
    %MAKETRAIN Creates struct containing data needed to create strainHistory
    %distanse between axles
    axleWeights = [60e3 80e3 60e3 80e3 60e3 80e3 60e3 ];
    axleDistances = [4 1.5 4 1.5 4 1.5];
    numberOfAxles = length(axleWeights);
    % The speed [m/s]
    v = 40;
    trainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v);
end

