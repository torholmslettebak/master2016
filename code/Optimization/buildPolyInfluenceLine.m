function [ infl ] = buildPolyInfluenceLine( x, delta, h, TrainData )
%BUILD Summary of this function goes here
t = 0:delta:TrainData.bridge_L;
% delta
% length(t)
% x
% h
% disp('here')
% h
infl = pchip(x, h, t);
end

