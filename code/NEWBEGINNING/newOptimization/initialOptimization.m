function [ initial_infl ] = initialOptimization( strainSignal, TrainData, length_infl, C )
% initialOptimization: Optimizes an initial influence line for 3
% parameters: height of peak, peak location, width of base of peak

peakLoc = 6;    % peak location in samples
peakHeight = 1e-7;  % inital magnitude guess
stepSize = 10; % in samples, also controls width of base of peak

h1 = [peakLoc peakHeight stepSize];
inflMat = @(h)(buildInflMat( strainSignal, TrainData, h, length_infl, C ));
leastSquareFun = @(h) sum( (strainSignal - (inflMat(round(h))*transpose(TrainData.axleWeights))) ).^2;
% min_error = inf;
% bestPeakLoc = 0;
% test = length_infl
% for i = stepSize:(length_infl)
%     h1(1) = i;
%     error = leastSquareFun(h1);
%     if error < min_error
%         bestPeakLoc = i;
%         min_error = error;
%     end
% end
[h, fval] = fmincon(leastSquareFun, h1);

initialAxis = 1:h1(3):length_infl;
initialInfl = zeros(length(initialAxis),1);
initialInfl(h1(1)) = h1(2);
initial_infl = pchip(initialAxis, initialInfl, 1:length_infl);
figure(12)
plot(1:length_infl, initial_infl);
close(12)
end

