function [ inflMat ] = buildInflMat( strainHistory, TrainData, h, length_infl, C )
% buildInflMat: puts toghether an influenceLine based on parameters in h =
% [peakLoc peakHeight stepSize], and the compiles a influence-matrix with
% the found influenceLine
% initialAxis = 1:h(3):length_infl;
% initialInfl = zeros(length(initialAxis),1);

% if (h(1)>1+h(3) && h(1)<length_infl-h(3))
%     initialInfl(h(1)) = h(2);
% else
%     initialInfl = ones(length(initialAxis), 1);
% end
% t = 1:length_infl;
% if length(initialAxis)~=length(initialInfl)
%     return;
% end
% disp(['length data points = ' num2str(length(initialAxis))]);
% disp(['length data values = ' num2str(length(initialInfl))]);
inflVec = spline(initialAxis, initialInfl, t);
inflMat = genInflMatFromCalcInflLine(inflVec, TrainData.axles, C);
figure(11)
plot(1:length_infl, inflVec)
hold on;
end

