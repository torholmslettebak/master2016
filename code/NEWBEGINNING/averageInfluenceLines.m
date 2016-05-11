function [ avgInfl, xvec ] = averageInfluenceLines( InflData, TrainData, samples_before, samples_after, shortest_Signal_before, shortest_Signal_after)
%AVERAGEINFLUENCELINES averages the found influence lines for the given
% train passages.
%   parameters: 
%   x_mat: contains the position vectors according to each influence vector,
%   infl_mat: contains the influence lines
%   TrainData: contains, speed, bridge_L, delta_t, osvosv
%   directionVector: the directions of infl_mat vectors

% Need to find the 

% samples_before = inf;
% samples_after = inf;
x_mat = InflData.x_values_infl_mat;
% x1_1 = x_mat(:,)
infl_mat = InflData.matrixMethod_infl_mat;
% sensorLoc = InflData.sensorLoc;
sizeVec = size(infl_mat); 
n = sizeVec(2); % number of influence lines
sumvector = zeros(samples_before + samples_after +1, 1);
for i = 1:n
    [~, index] = max(infl_mat(:,i));
    newInfl = infl_mat(index-samples_before:index+samples_after, i);
    sumvector = sumvector + newInfl;
end
avgInfl = sumvector/n;
% [~, index] = max(infl_mat(:,1));
numberOfSamplesWanted = samples_before + samples_after;
dx = TrainData.delta * TrainData.speed;
x = [0:numberOfSamplesWanted]*dx;
xvec = shiftInfluenceLine(InflData.sensorLoc, avgInfl, x);
figure(21)
plot(xvec, sgolayfilt(avgInfl,3,71));
title('filtered averaged influence line')
legend('avg_sgolay_k3f71');
matlab2tikz('..\..\thesis\tikz\smoothed_infl.tex', 'height', '\figureheight', 'width', '\figurewidth');

% close(21);
% xvec = x_mat(before:after, 1);
end

