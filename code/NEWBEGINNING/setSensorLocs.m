function [ L_a, L_b, L_c, sensorLocs ] = setSensorLocs( )
% Sets or resets sensorlocs to given values
% Distance from reaction A to the middle sensor
L_a = 4.17/2;
% Distance from reaction A to sensor nearest Trondheim
L_b = L_a - 1;
% Distance from reaction A to sensor nearest Heimdal
L_c = L_a + 1;
sensorLocs = [L_a L_b L_c];
end

