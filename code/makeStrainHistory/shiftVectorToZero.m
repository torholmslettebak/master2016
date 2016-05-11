function [ shiftedVector ] = shiftVectorToZero( vector )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

shiftedVector = vector - mean(vector(1:100));

end

