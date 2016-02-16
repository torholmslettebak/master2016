% needs the influence line, axle distance, and time stuff
function ordinateMatrix = createInfluenceOrdinateMatrix(t,axleWeights, v, L, a, b, c, d, L_a, d_a)
numberOfAxles = length(axleWeights);
ordinateMatrix = zeros(length(t), numberOfAxles);
% axlePos = zeros(numberOfAxles);
    for i = 1:(length(t))
        s1 = v*t(i);
%         axlePos(1) = s1;
        ordinateVector = zeros(1,numberOfAxles);
        for axle = 1:numberOfAxles
            if (s1 - d_a*(axle-1))>0 && (s1 <= (L+ d_a*(axle-1)))
%                 disp(['I am axle ' num2str(axle) ' and I am at s = ' num2str(s1 - d_a*(axle-1))])
                ordinateVector(1,axle) = getOrdinateValue(a,b,c,d,s1-d_a*(axle-1), L_a);
            end
        end
        ordinateMatrix(i,1:numberOfAxles) = ordinateVector;
    end
end


