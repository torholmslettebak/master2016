% Code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code

clf
% Lengt of bridge [m]
L = 30;
% Number of sensors
n = 2;
% Distance between sensors
n_d = 5;
% Distane from reaction A to first sensor
L_a = 5;
% Distance from reaction A to furthest sensor
L_b = 25;

clf


function [a, b, c, d] =  generateInfluenceLine(L, L_a)
	magnitude = L_a*(1- L_a / L);
	a = magnitude/L_a;
	b=0;
	c = -magnitude/(L-L_a);
	d = magnitude;
end

function [yValue,x] =  drawInfluenceLine(a, b, c, d, L_a, L)
	x1 = 0:L_a;
	x2 = L_a:L;
	y1 = a*x1 + b;
	y2 = c*(x2-L_a) + d;
	y2(1) = [];
	x2(1) = [];
	x = [x1, x2];
	y = [y1,y2];
	yValue = y;
	% plot(x,y)
end

% The first sensor
[a,b,c,d] = generateInfluenceLine(L, L_a)
[sensor1Vector, x1] = drawInfluenceLine(a,b,c,d, L_a, L);
hold on
% The second sensor
[a,b,c,d] = generateInfluenceLine(L, L_b)
[sensor2Vector, x2] = drawInfluenceLine(a,b,c,d, L_b, L);
disp('length')
length(sensor1Vector)
%  Now, lets introduce some moving loads, lets begin with 1
% The speed [m/s]
v = 1;  % should use 30 seconds to pass the bridge
% The load [N]
p1 = 1000*10^10;
% E modulus
E = 200*10^9;
% Section modulus (IPE 300 mm^3)
Z = 3.14e5 * 1000^3;
% Lets first try with only one sensor, sensor1 whose Influence data is stored in sensor1Vector
epsilonS1 = 0:30;
for t = 0:30
	s = v*t;
	epsilonS1(t+1) = sensor1Vector(s+1) * p1 /(E*Z);
end

plot(x1, epsilonS1)