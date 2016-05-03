function [ hNew, h_pos_vec ] = findInitialGuessValues( x,  h, TrainData, sensorLoc, x1, x2)
%Meant to create polynomial values for an inital guess of an influence line
%   This will be done through creating polynomial interpolating magnitude point over sensorLoc, and
%   from this extract values from given interval x positions.
%   This will be used to create a good initial guess for
%   influenceLineOptimization.

magnitude = sensorLoc*(1- sensorLoc / TrainData.bridge_L);
locLeft = x1(round(length(x1)/2));
locRight = x2(round(length(x2)/2));
% if sensorLoc > TrainData.bridge_L/2
%     disp('here')
%     fwtm = TrainData.bridge_L - sensorLoc; % full with at tenth of maximum
% else
%     disp('there')
%     fwtm = sensorLoc;
% end
% c = fwtm/(2*sqrt(2*log(10)));
% a = (1/(c*sqrt(2*pi))); % The heigth of the curve's beak
% b = sensorLoc; % The position of the center of the peak
% f = a*exp(-(((x-b).^2)/(2*c^2)));
% scale = findScale(f, magnitude);
% f = f*scale;
% figure(10)
% plot(x,f)
p = [0 locLeft x1(length(x1)) locRight x(length(x))];
f = pchip(p, [0 magnitude/2 magnitude magnitude/2 0], x);
% p = [0 x1(length(x1)) x(length(x))];
% f = pchip(p, [0 magnitude 0], x);


pointsBeforeSensor = length(x1)*100/length(x); % in percent
pointsAftersensor = 100-pointsBeforeSensor; % in percent
samplingPointsBefore = round((length(h)-3)*pointsBeforeSensor/100); %-3 because first last and magnitude point have set values
samplingPointsAfter = round((length(h)-3)*pointsAftersensor/100);
indArr = splitArray(length(f), length(h));
interValsX1 = splitArray(length(x1), samplingPointsBefore+1); % +2 because of first point and magnitude point
interValsX2 = splitArray(length(x2), samplingPointsAfter+1);
interVals = [interValsX1 interValsX2];
% How many sample points from 0 to max value position  == length(x1)

h_pos_vec = ones(1, length(h));
sum(interVals)
for i = 2:length(interVals)
   h_pos_vec(i) = sum(interVals(1:i-1)); 
end
h_pos_vec(length(h_pos_vec)) = sum(interVals);
hNew = zeros(1,length(h));
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

