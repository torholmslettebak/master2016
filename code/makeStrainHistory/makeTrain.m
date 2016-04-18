function [ trainData ] = makeTrain(speed)
    %MAKETRAIN Creates struct containing data needed to create strainHistory
    %distanse between axles
    axleWeights = [9.5 9.5 9.5 9.5 14.575 14.575 14.575 14.575]*10^3;
%     axleDistances = [2.5 10.9 2.5, 5.3 2.5 10.9];
    axleDistances = [2.5 14 2.5 5.125 2.55 13.975 2.5];
%     axleWeights = [10e3 10e3 10e3 10e3 ];
%     axleDistances = [2.5 10.9 2.5 ];
    numberOfAxles = length(axleWeights);
    % The speed [m/s]
%     v = 20.9875;
    if nargin>0
        v = speed;
    else
%         v = 20.99;  % Train 3
        v = 21.8; % Train 4
%         v = 20.474  % Train 5      
%         v = 20.633; % Train 8
    end
%     v = 30;
    % Lengt of bridge [m]
    L = 25;
    delta_t = 1/1024;
    if length(axleWeights) > 1
        t = 0:delta_t:( (L+sum(axleDistances))/v);
    else
        t = 0:delta_t:(L+1)/v;
    end
    trainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v, 'delta', delta_t, 'time', t, 'bridge_L', L);
end

