% updated code can be found at: https://github.com/torholmslettebak/master2016/tree/master/code

clf
% Lengt of bridge [m]
L = 30;
% Number of sensors
n = 2;
% Distance between sensors
n_d = 5;
%number of axles
% n_a = 4;
%distanse between axles
d_a = 1;
% Distane from reaction A to first sensor
L_a = 10;
% Distance from reaction A to furthest sensor
L_b = 20;

axleWeights = [1000 1000];
numberOfAxles = length(axleWeights);

% The speed [m/s]
v = 1;  % should use 30 seconds to pass the bridge
% E modulus N/m^2
E = 200*10^9;
% Section modulus (IPE 300 m^3)
Z = 3.14e5 / (1000^3);

if(numberOfAxles > 1)
	t = 0:0.01:( (L+(numberOfAxles -1)*d_a)/v);
else
	t = 0:0.01:(L+1)/v;
end
[a,b,c,d] = generateInfluenceLine(L, L_a);
ordinateMatrix = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_a, d_a);

strainHist = calcStrainHist(ordinateMatrix, axleWeights, E, Z);

% plot(t, strainHist)
hold on
[a,b,c,d] = generateInfluenceLine(L, L_b);
ordinateMatrix2 = createInfluenceOrdinateMatrix(t, axleWeights, v, L, a, b, c, d, L_b, d_a);
strainHist2 = calcStrainHist(ordinateMatrix2, axleWeights, E, Z);

calculatedSpeed = speed( strainHist, strainHist2 , t , L, L_a, L_b);
disp(['calculated speed ' num2str(calculatedSpeed) ]);

plot(t, strainHist, t, strainHist2)
theTitle = ['Calculated strain history for ' num2str(numberOfAxles) ' train axles'];
title(theTitle);
xlabel('time [s]');
ylabel('Strain');
legend('Sensor1', 'Sensor2')
