% needs the influence line, axle distance, and time stuff
function ordinateMatrix = createInfluenceOrdinateMatrix(t, v, L, a, b, c, d, L_a, axleDistances)
numberOfAxles = length(axleDistances)+1;
ordinateMatrix = zeros(length(t), numberOfAxles);
% axlePos = zeros(numberOfAxles);
    for i = 1:(length(t))
        s1 = v*t(i);
%         axlePos(1) = s1;
        ordinateVector = zeros(1,numberOfAxles);
        for axle = 1:numberOfAxles
           if (s1 - sum(axleDistances(1:axle-1)))>0 && (s1 <= (L + sum(axleDistances(1:axle-1))))
               ordinateVector(1,axle) = getOrdinateValue(a,b,c,d,s1-sum(axleDistances(1:axle-1)), L_a);
           end
        end
        ordinateMatrix(i,1:numberOfAxles) = ordinateVector;
    end
    
end


