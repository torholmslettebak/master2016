function v  = speed( eps1, eps2, t , L, L_a, L_b)
% calculates the speed based on the peaks of the strain history for two
% different sensors
[max1, index1] = max(eps1(:));
disp('length of index1');
disp(length(index1));
[max2, index2] = max(eps2(:));
[maxTime, indT] = max(t(:))
distSensors = L_b - L_a;
disp('dist between sensors')
disp(distSensors)
disp(['first peak at t = ' num2str(t(index1)) ' the second peak at t = ' num2str(t(index2))])
deltaT = t(index2) - t(index1);
disp('delta t')
disp(deltaT)
v = distSensors/deltaT;
end

