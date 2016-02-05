function v  = speed( eps1, eps2, t , L, L_a, L_b)
% calculates the speed based on the peaks of the strain history for two
% different sensors

[pks, locs] = findpeaks(eps1);
disp('the peaks of shist1');
disp(pks);
disp(['the locs: ' num2str(t(locs(1))) ' and ' num2str(t(locs(2)))]);
% disp(locs);

[pks2, locs2] = findpeaks(eps2);
% disp('the peaks of shist1');
% disp(pks);
% disp(['the locs: ' num2str(t(locs2(1))) 'and ' num2str(t(locs2(2)))]);


[max1, index1] = max(eps1(:));
[max2, index2] = max(eps2(:));
% [maxTime, indT] = max(t(:))
distSensors = L_b - L_a;
% disp('dist between sensors')
% disp(distSensors);
% disp(['first peak at t = ' num2str(t(index1)) ' the second peak at t = ' num2str(t(index2))])
deltaT = t(locs2(1)) - t(locs(1));
% disp('delta t')
% disp(deltaT)
v = distSensors/deltaT;
end

