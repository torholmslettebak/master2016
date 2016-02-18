% needs the influence line, axle distance, and time stuff
% t, TrainData, a,b,c,d, L_a
function ordinateMatrix = createInfluenceOrdinateMatrix(t, TrainData, L, a, b, c, d, L_a)
numberOfAxles = length(TrainData.axleDistances)+1;
ordinateMatrix = zeros(length(t), numberOfAxles);
% axlePos = zeros(numberOfAxles);
    for i = 1:(length(t))
        s1 = TrainData.speed*t(i);
%         axlePos(1) = s1;
        ordinateVector = zeros(1,numberOfAxles);
        for axle = 1:numberOfAxles
           if (s1 - sum(TrainData.axleDistances(1:axle-1)))>0 && (s1 <= (L + sum(TrainData.axleDistances(1:axle-1))))
               ordinateVector(1,axle) = getOrdinateValue(a,b,c,d,s1-sum(TrainData.axleDistances(1:axle-1)), L_a);
           end
        end
        ordinateMatrix(i,1:numberOfAxles) = ordinateVector;
    end
    
end


