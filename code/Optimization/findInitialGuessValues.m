function [ hNew, h_pos_vec ] = findInitialGuessValues( x,  h, TrainData, sensorLoc, x1, x2)
%Meant to create polynomial values for an inital guess of an influence line
%   This will be done through creating a gauss bell distribution, and
%   from this extract values from given interval x positions.
%   This will be used to create a good initial guess for
%   influenceLineOptimization.
magnitude = sensorLoc*(1- sensorLoc / TrainData.bridge_L);
if sensorLoc > TrainData.bridge_L/2
    disp('here')
    fwtm = TrainData.bridge_L - sensorLoc; % full with at tenth of maximum
else
    disp('there')
    fwtm = sensorLoc;
end
log(10)
c = fwtm/(2*sqrt(2*log(10)));
a = (1/(c*sqrt(2*pi))); % The heigth of the curve's beak
b = sensorLoc; % The position of the center of the peak
f = a*exp(-(((x-b).^2)/(2*c^2)));
scale = findScale(f, magnitude);
f = f*scale;
% figure(10)
% plot(x,f)

hSplitArr = splitArray(length(h), 2);
interValsX1 = splitArray(length(x1), hSplitArr(1));
interValsX2 = splitArray(length(x2), hSplitArr(2));
interVals = [interValsX1 interValsX2];
sumIntervals = sum(interVals);
indArr = splitArray(length(f), length(h));
hNew = zeros(1,length(h));
h_pos_vec = ones(1, length(h));
for i = 2:length(h)
   h_pos_vec(i) = sum(interVals(1:i-1)); 
end
for i = 1: length(indArr)
%    h_pos_vec(i) = sum(interVals(1:i));
%    hNew(i) = f(sum(indArr(1:i))); 
   hNew(i) = f(h_pos_vec(i)); 
end
% indArr = splitArray(length(f), length(h)-1);
% h_pos_vec2 = ones(1, length(h));

% h_pos_vec = h_pos_vec2;
figure(10)
plot(x,f)
close(10)
end

