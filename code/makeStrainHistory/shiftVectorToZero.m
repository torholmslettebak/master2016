function [ shiftedVector ] = shiftVectorToZero( vector )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% if length(vector)> 200000
% shiftedVector = vector - mean(vector(1:100000));
% else
shiftedVector = vector - mean(vector(1:100));
% end  
end

