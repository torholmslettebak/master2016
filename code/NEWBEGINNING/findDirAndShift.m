function [ TrainData, L_a, L_b, L_c, trainDirection, sensorLocs ] = findDirAndShift( TrainData, s2, s3, sensorLocs )
% Finds direction of the train and shift the sensorLocations and also shift
% axle distances and weights of the calibration train
trainDirection = sign(speedByCorrelation(s2, s3, TrainData.time, 2, TrainData.delta)); % -1 <=> towards heimdal, 1 <=> towardsTrondheim
if(trainDirection == -1) % Train goes towards heimdal
    L_a = sensorLocs(1);
    L_b = sensorLocs(2);
    L_c = sensorLocs(3);
elseif trainDirection == 1 % Train goes towards Trondheim
    L_a = TrainData.bridge_L - sensorLocs(1);
    L_b = L_a + 1;
    L_c = L_a - 1;
    TrainData.axleDistances = fliplr(TrainData.axleDistances);
    TrainData.axleWeights = fliplr(TrainData.axleWeights);
    sensorLocs = [L_a L_b L_c];
else
    disp('the strainHistories are identical or nonexistant')
    return;
end


end

