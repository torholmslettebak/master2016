function [ infl ] = buildPolyInfluenceLine( x, delta, h, TrainData )
%BUILD Summary of this function goes here
t = 0:delta:TrainData.bridge_L;
infl = pchip(x, h, t);
end

