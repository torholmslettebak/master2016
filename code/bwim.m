% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code

clear; clc; clf;

% Lengt of bridge [m]
L = 30;
% Number of sensors
n = 2;
% Distance between sensors
n_d = 5;
%number of axles
% n_a = 4;
%distanse between axles
d_a = 3;
% Distane from reaction A to first sensor
L_a = 5;
% Distance from reaction A to furthest sensor
L_b = 25;

axleWeights = [10000 1000 10000 1000 10000 1000 10000 1000 10000];
numberOfAxles = length(axleWeights);

% The speed [m/s]
v = 7;  % should use 30 seconds to pass the bridge
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);

if(numberOfAxles > 1)
	t = 0:0.001:( (L+(numberOfAxles -1)*d_a)/v);
else
	t = 0:0.001:(L+1)/v;
end
clf(1)
[a,b,c,d] = generateInfluenceLine(L, L_a);
fillInfluenceLine(a, b, c, d, L_a, L);
ordinateMatrix = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_a, d_a);

strainHist = calcStrainHist(ordinateMatrix, axleWeights, E, Z);
% Add white gaussian noise to strain signal
y = awgn(strainHist, 40, 'measured');


hold on
[a,b,c,d] = generateInfluenceLine(L, L_b);
fillInfluenceLine(a, b, c, d, L_b, L);
ordinateMatrix2 = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_b, d_a);
strainHist2 = calcStrainHist(ordinateMatrix2, axleWeights, E, Z);

% calculatedSpeed = speed( strainHist, strainHist2, t , L, L_a, L_b);
% disp(['calculated speed ' num2str(calculatedSpeed) ]);
speedByCorrelation(strainHist,strainHist2,t, L_b - L_a);
figure(2)
plot(t, strainHist, t, strainHist2, t, y)
theTitle = ['Calculated strain history for ' num2str(numberOfAxles) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2', 'sensor1 with awgn')

