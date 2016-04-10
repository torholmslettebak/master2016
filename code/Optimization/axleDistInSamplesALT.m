function [ C ] = axleDistInSamplesALT( lengthStrain, axleDistances )
% Finds axle distances in samples, based on length of a strain vector and
% the distance between axles.
Ctemp = zeros(1, length(axleDistances));
trainLength = sum(axleDistances);
for i = 1:length(axleDistances)
    Ctemp(i) = round((trainLength/axleDistances(i))/lengthStrain);
end
C = zeros(1, length(axleDistances)+1);
for i = 2 : length(axleDistances)+1;
    C(i) = sum(Ctemp(1:i-1));
end

end

