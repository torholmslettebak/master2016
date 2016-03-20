function [ filtered ] = movingAvgFilt( unfiltered, N )
%   signal smoothing through the moving average method
%   averaging each sampling with the previous and afterwards N samples
test = filter(ones(1, 2*N+1)/(2*N+1), 1, unfiltered);
filtered = unfiltered;
filtered(N+1:end-N) = test(2*N+1:end);
end

