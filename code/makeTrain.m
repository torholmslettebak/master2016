function [ trainData ] = makeTrain( )
    %MAKETRAIN Creates struct containing data needed to create strainHistory
    %distanse between axles
    axleWeights = [10e3 10e3 10e3 10e3];
    axleDistances = [2.5 10.9 5.3];
%     axleWeights = [10e3 10e3 10e3 10e3 ];
%     axleDistances = [2.5 10.9 2.5 ];
    numberOfAxles = length(axleWeights);
    % The speed [m/s]
    v = 3.5;
    % Lengt of bridge [m]
    L = 20;
    delta_t = 1e-3;
    if length(axleWeights) > 1
        t = 0:delta_t:( (L+sum(axleDistances))/v);
    else
        t = 0:delta_t:(L+1)/v;
    end
    trainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v, 'delta', delta_t, 'time', t, 'bridge_L', L);
end

