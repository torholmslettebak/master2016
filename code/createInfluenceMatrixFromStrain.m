function ordinateMatrix = createInfluenceMatrixFromStrain(L_a, calculatedAxleDistances, TrainData)
numberOfAxles = length(calculatedAxleDistances)+1;
t = TrainData.time;
ordinateMatrix = zeros(length(t), numberOfAxles);
v = TrainData.speed;
L = TrainData.bridge_L;
[a,b,c,d] = generateInfluenceLine(TrainData.bridge_L, L_a);
    for i = 1:(length(t))
        s1 = v*t(i);
        ordinateVector = zeros(1,numberOfAxles);
        for axle = 1:numberOfAxles
            if (s1 - sum(calculatedAxleDistances(1:axle-1)))>0 && (s1 <= (L + sum(calculatedAxleDistances(1:axle-1))))
                ordinateVector(1,axle) = getOrdinateValue(a,b,c,d,s1-sum(calculatedAxleDistances(1:axle-1)), L_a);                
            end
        end
        ordinateMatrix(i,1:numberOfAxles) = ordinateVector;
    end
end