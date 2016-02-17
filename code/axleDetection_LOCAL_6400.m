function [ axledist ] = axleDetection( strainHist, t, speed)
% Detects each axle, and finds the distance between them
% Axles can be found through the peaks of the strain curve
% two derivations of the strain curve will find the absolute value of the
% peaks

firstDerivative = diff(strainHist);
x1 = 0:length(firstDerivative)-1;
secondDerivative = diff(firstDerivative);
x2 = 0:length(secondDerivative)-1;
[pks, locs, w, p] = findpeaks((secondDerivative),'MinPeakProminence',0.00000000000001); 
%MINPEAKPROMINENCE should be based on input weights.. 
%if weights arent large enough peaks will not be accommodated for

figure(3)
clf(3)
plot(t(1:length(t)-1), firstDerivative, t(1:length(t)-2), secondDerivative)
hold on
% plot()
title('Derivations of strain history');
xlabel('index of strain history');
ylabel('derivative value');
legend('First Derivative', 'Second Derivative')
% disp('max2')
% disp(pks)
% disp('index2')
% disp(locs)
% disp('p')
% disp(p)

disp('time between axles')
disp( t(locs(2)+2)); 
disp( t(locs(1)+2));
axledist = speed * ((t(locs(2)+2) - (t(locs(1)+2  ))));
end

