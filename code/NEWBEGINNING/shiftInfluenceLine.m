function [ newX ] = shiftInfluenceLine( sensorLoc, infl, x )
%SHIFTINFLUENCELINE Summary of this function goes here
%   Detailed explanation goes here

[~, index] = max(infl);
% The index of max should be over the sensorLoc on the bridge
if x(index)<=sensorLoc
%    Shift x-vector towards left
    shiftVal = x(index) - sensorLoc;
    newX = x - shiftVal;
else
    shiftVal =  sensorLoc - x(index);
    newX =  x + shiftVal;
end


end

