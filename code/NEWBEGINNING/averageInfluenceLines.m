function [ output_args ] = averageInfluenceLines( InflData, TrainData)
%AVERAGEINFLUENCELINES averages the found influence lines for the given
% train passages.
%   parameters: 
%   x_mat: contains the position vectors according to each influence vector,
%   infl_mat: contains the influence lines
%   TrainData: contains, speed, bridge_L, delta_t, osvosv
%   directionVector: the directions of infl_mat vectors

% Need to find the 

samples_before = inf;
samples_after = inf;
x_mat = InflData.x_values_infl_mat;
infl_mat = InflData.matrixMethod_infl_mat;
sensorLoc = InflData.sensorLoc;
sizeVec = size(infl_mat); 
n = sizeVec(2); % number of influence lines
for i = 1:n
    %find the signal with the least sensors before sensorLoc
    currentVec = x_mat(:,i);
    before = length(currentVec(currentVec<sensorLoc));
    after = length(currentVec(currentVec>sensorLoc));
    if samples_before > before
        samples_before = before;
    end
    if samples_after > after
        samples_after = after;
    end
end

end

