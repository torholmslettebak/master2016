function ordinateMatrix = createInfluenceOrdinateMatrix(t, v, L, a, b, c, d, L_a, axleDistances)
numberOfAxles = length(axleDistances)+1;
ordinateMatrix = zeros(length(t), numberOfAxles);
% axlePos = zeros(numberOfAxles);
disp(numberOfAxles)
    for i = 1:(length(t))
        s1 = v*t(i);
        
        ordinateVector = zeros(1,numberOfAxles);
        
%         disp(['I am s1 = ' num2str(s1)])
%         ordinateVector(1,1) = getOrdinateValue(a,b,c,d,s1, L_a)
        for axle = 1:numberOfAxles
%             disp(['axle is: ' num2str(axle) ' and if loop ' num2str((s1 - sum(axleDistances(1:axle-1))))])
%              sum(axleDistances(1:axle))
            if (s1 - sum(axleDistances(1:axle-1)))>0 && (s1 <= (L + sum(axleDistances(1:axle-1))))
%                 disp(['I am axle ' num2str(axle) ' and I am at s = ' num2str(s1 - d_a*(axle-1))])
                
                ordinateVector(1,axle) = getOrdinateValue(a,b,c,d,s1-sum(axleDistances(1:axle-1)), L_a);
            end
        end
        ordinateMatrix(i,1:numberOfAxles) = ordinateVector;
    end
end