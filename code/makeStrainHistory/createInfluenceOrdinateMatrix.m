% needs the influence line, axle distance, and time stuff
function ordinateMatrix = createInfluenceOrdinateMatrix(TrainData, a, b, c, d, L_a)
numberOfAxles = length(TrainData.axleDistances)+1;
L = TrainData.bridge_L;
t = TrainData.time;
ordinateMatrix = zeros(length(t), numberOfAxles);

    for i = 1:(length(t))
        s1 = TrainData.speed*t(i);
        ordinateVector = zeros(1,numberOfAxles);
        for axle = 1:numberOfAxles
           if (s1 - sum(TrainData.axleDistances(1:axle-1)))>0 && (s1 <= (L + sum(TrainData.axleDistances(1:axle-1))))
               ordinateVector(1,axle) = getOrdinateValue(a,b,c,d,s1-sum(TrainData.axleDistances(1:axle-1)), L_a);
           end
        end
        ordinateMatrix(i,1:numberOfAxles) = ordinateVector;
    end
    
end


