function [ trainData ] = makeTrain( )
    %MAKETRAIN Creates struct containing data needed to create strainHistory
    %distanse between axles
axleWeights = [9.5 9.5 9.5 9.5 14.575 14.575 14.575 14.575]*10^3;
%     axleDistances = [2.5 10.9 2.5, 5.3 2.5 10.9];
    axleDistances = [2.5 14 2.5 5.125 2.55 13.975 2.5];
%     axleWeights = [10e3 10e3 10e3 10e3 ];
%     axleDistances = [2.5 10.9 2.5 ];
    numberOfAxles = length(axleWeights);
    % The speed [m/s]
    v = 23;
    % Lengt of bridge [m]
    L = 30;
    delta_t = 1e-3;
    if length(axleWeights) > 1
        t = 0:delta_t:( (L+sum(axleDistances))/v);
    else
        t = 0:delta_t:(L+1)/v;
    end
    trainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v, 'delta', delta_t, 'time', t, 'bridge_L', L);
end

