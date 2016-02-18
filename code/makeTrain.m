function [ trainData ] = makeTrain( )
%MAKETRAIN Summary of this function goes here
%   Detailed explanation goes here
% Lengt of bridge [m]
L = 20;
% Number of sensors
% n = 2;
%distanse between axles
d_a = 1;
% Distane from reaction A to first sensor
L_a = 10;
% Distance from reaction A to furthest sensor
L_b =15;

axleWeights = [10000 10000 10000 10000 10000 10000];
axleDistances = [2 1 3 4 1];
% 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 10000 10000 10000 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 10000 10000 10000 0 0 0
numberOfAxles = length(axleWeights);
numberOfAxleDistances = length(axleDistances);
% The speed [m/s]
v = 20;
trainData = struct('axleWeights', axleWeights, 'axles', numberOfAxles, 'axleDistances', axleDistances, 'speed', v);

end

