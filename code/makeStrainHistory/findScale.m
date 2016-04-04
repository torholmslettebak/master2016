function [ scale ] = findScale( curve, targetValMaxPoint )
% Finds value used to scale currentVal to targetVal
maxVal = max(curve);

scale = targetValMaxPoint/maxVal;

end

