function [ infl ] = buildPolyInfluenceLine( x, delta, h, TrainData, t )
%BUILD Summary of this function goes here
% t = 0:delta:TrainData.bridge_L;
% delta
% length(t)
% x
% h
% disp('here')
% h
infl = spline(x, h, t);
figure(16)
plot(t, infl);
close(16);
end

