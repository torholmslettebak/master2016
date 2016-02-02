% Code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code

clf
% Lengt of bridge [m]
L = 30;
% Number of sensors
n = 2;
% Distance between sensors
n_d = 5;
%number of axles
n_a = 3
%distanse between axles
d_a = 1;
% Distane from reaction A to first sensor
L_a = 15;
% Distance from reaction A to furthest sensor
L_b = 25;

axleWeights = [5000 10000 15000];
clf


function [a, b, c, d] =  generateInfluenceLine(L, L_a)
	magnitude = L_a*(1- L_a / L);
	a = magnitude/L_a;
	b=0;
	c = -magnitude/(L-L_a);
	d = magnitude;
end

function [yValue,x] =  fillInfluenceLine(a, b, c, d, L_a, L)
	x1 = 0:0.001:L_a;
	x2 = L_a:0.001:L;
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
[infS1, x1] = fillInfluenceLine(a,b,c,d, L_a, L);
hold on
% The second sensor
% [a,b,c,d] = generateInfluenceLine(L, L_b)
% [sensor2Vector, x2] = fillInfluenceLine(a,b,c,d, L_b, L);
% disp('length')
% length(infS1)
%  Now, lets introduce some moving loads, lets begin with 1
% The speed [m/s]
v = 1;  % should use 30 seconds to pass the bridge
% The load [N]
p1 = 10000;
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);
% Lets first try with only one sensor, sensor1 whose Influence data is stored in infS1
epsilonS1 = 0:0.001:30;
counter = 1;
for t = 0:0.001:30
	s = v*t;
	epsilonS1(counter) = infS1(counter) * p1 /(E*Z)    + 0.00001*sin(pi*t/2); %sin function for noise
	counter++;
end

% t - time vector, axleLoad in Newton, E - Elasticity modulus, Z - section modulus, v speed [m/s], infS influence line for sensor
function strain = calcStrainHistory(t, axleLoad, E, Z, v, infS, L)
	counter = 1;
	s = 0;
	strain = zeros(1, length(t));
	while s<L
		s=v*t
	end
end

plot(x1, epsilonS1)

timeAxlePosHistory = zeros(length(t), n_a +1);
% fill time

for i = 1:length(t)
	timeAxlePosHistory(i,1) = t(i);
end

function y = getOrdinateValue(a,b,c,d, pos, L_a)
	if (pos<=L_a)
		y = a*pos + b;
	else
		y =c*(pos-L_a) + d;
	end
	% disp(y);
end		

% needs the influence line, axle distance, and time stuff
function ordinateMatrix = createInfluenceOrdinateMatrix(t,axleWeights, v, L, a, b, c, d, L_a, d_a)
	numberOfAxles = length(axleWeights);
	ordinateMatrix = zeros(length(t), numberOfAxles);
	train = zeros(1,numberOfAxles);
	while sum(train) <numberOfAxles
		for i = 1:(length(t))
			s1 = v*t(i);
			if s1<=30
				y1 = getOrdinateValue(a, b, c, d, s1, L_a);
				ordinateVector = zeros(1,numberOfAxles);
				ordinateVector(1,1) = y1;
			else
				train(1,1) = 1;
			end
			% ordinateMatrix(1,1:numberOfAxles) = ordinateVector(1:numberOfAxles)
			if numberOfAxles>1
				for axle = 2:numberOfAxles
					% disp(d_a*(axle-1))
					if (s1 >= d_a*(axle-1)) && (s1 <= (L+ d_a*(axle-1)))
						ordinateVector(1,axle) = getOrdinateValue(a,b,c,d,s1-d_a*(axle-1), L_a);
					else
						train(1, axle) = 1;
					end

					% if s1-d_a*(axle-1) >30
					% 	train(1, axle) = 1;
					% end
				end
				% 
			end
			ordinateMatrix(i,1:numberOfAxles) = ordinateVector(1:numberOfAxles);
		end
	end
end

function strainHist = calcStrainHist(ordinateMatrix, axleWeights, E, Z)
	% strainHist =zeros(length(ordinateMatrix(:,1)),1);
	strainHist = (1/(E*Z)) * ordinateMatrix * transpose(axleWeights);
end

t = 0:0.1:( (L+(n_a -1)*d_a)/v);
ordinateMatrix = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_a, d_a);

strainHist = calcStrainHist(ordinateMatrix, axleWeights, E, Z)
plot(t, strainHist)
