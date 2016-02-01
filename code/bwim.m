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


function [a,b, c, d] =  generateInfluenceLine(L, L_a)
	magnitude = L_a*(1- L_a / L);
	a = magnitude/L_a;
	b=0;
	c = -magnitude/(L-L_a);
	d = magnitude;
end

function yValue =  drawInfluenceLine(a, b, c, d, L_a, L)
	x1 = 0:0.01:L_a;
	x2 = L_a:0.01:L;
	y1 = a*x1 + b;
	y2 = c*(x2-L_a) + d;
	y2(1) = [];
	x2(1) = [];
	x = [x1, x2];
	y = [y1,y2];
	yValue = y;
	plot(x,y)
end
[a,b,c,d] = generateInfluenceLine(L, L_a)
sensor1Vector = drawInfluenceLine(a,b,c,d, L_a, L);
hold on
[a,b,c,d] = generateInfluenceLine(L, L_b)
sensor2Vector = drawInfluenceLine(a,b,c,d, L_b, L);