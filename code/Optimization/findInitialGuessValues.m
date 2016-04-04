function [ hNew ] = findInitialGuessValues( x,  h, TrainData, sensorLoc)
%Meant to create polynomial values for an inital guess of an influence line
%   This will be done through creating a gauss bell distribution, and
%   from this extract values from given interval x positions.
%   This will be used to create a good initial guess for
%   influenceLineOptimization.
magnitude = sensorLoc*(1- sensorLoc / TrainData.bridge_L);
splitArr = splitArray(length(x), 2);
% a = -splitArr(1);
% a = -100;
% a = -splitArr(1);
% b = -a;
% xNew = a + (b-a) * rand(1,500);
% xNew = 2*a * rand(1,500);
% m = (a + b)/2;
% m = 30;
% s = 30;
% p1 = -.5 * ((xNew - m)/s) .^ 2;
% p2 = (s * sqrt(2*pi));
% f = 1000*exp(p1) ./ p2; 
c = 2.5;   % The standard deviation, controls the width of the "bell"
a = (1/(c*sqrt(2*pi))); % The heigth of the curve's beak
b = mean(x) + (sensorLoc - mean(x)); % The position of the center of the peak
f = a*exp(-(((x-b).^2)/(2*c^2)));
scale = findScale(f, magnitude);
f = f*scale;
% figure(10)
% plot(x,f)

indArr = splitArray(length(f), length(h));
hNew = zeros(1,length(h));
for i = 1: length(indArr)
   sum(indArr(1:i))
   hNew(i) = f(sum(indArr(1:i))); 
end
% figure(10)
% plot(x,f)
% hold on;
end

