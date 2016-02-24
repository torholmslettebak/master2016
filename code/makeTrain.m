function [ trainData ] = makeTrain( )
    %MAKETRAIN Creates struct containing data needed to create strainHistory
    %distanse between axles
    axleWeights = [6e3 6e3 6e3 6e3 6e3 6e3 6e3 6e3 ];
    axleDistances = [2.5 13.4 15.9 21.2 23.7 34.6 37.1];
    numberOfAxles = length(axleWeights);
    % The speed [m/s]
    v = 20;
    % Lengt of bridge [m]
    L = 40;
    delta_t = 0.001;
    if length(axleWeights) > 1
        t = 0:delta_t:( (L+sum(axleDistances))/v);
    else
        t = 0:delta_t:(L+1)/v;
    end
    trainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v, 'delta', delta_t, 'time', t, 'bridge_L', L);
end

