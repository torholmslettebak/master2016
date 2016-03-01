function [  M_c, A ] = findInfluenceLines( axle_weights, strainHistory, axleDistances, speed, delta_t)
% This method will find the influence lines for a given strain history
% This will be acomplished through Moses' equation
% The axle loads [A] are known, so the influence ordinates which minimises
% the following equation give best the best solution
% E = sum_from_k=1_to_k=numOfScans((M_k^M - M_k^T)^2)
% M_k^M = measured bending moment at scan k - measured response
% M_k^T = theoretical response
frequency = 1/delta_t;
k = length(strainHistory)
n = length(axle_weights);
C_n = round(sum(axleDistances)*frequency/speed);
C = zeros(1,n);
C(1) = 0;
for i = 1:n-1
        C(i+1) = round((sum(axleDistances(1:i)))*frequency/speed);
end


M_c = zeros(k-C_n, 1);
for i = 1:k-C_n
    for j = 1:n
        M_c(i,1) = M_c(i,1) + axle_weights(j)*strainHistory(i+C(j));
    end
end
% Now creating the A matrix, which depends on the axle weights
% The diagonal <-> sum of the squares of the axle weights
A = zeros(k-C_n, k-C_n);

for i = 1:n
    for j = 1:n
%         disp(['i = ' num2str(i) ' j = ' num2str(j)]);
%         disp(['C(j) - C(i) = ' num2str(C(j) - C(i))]);
%         disp(['((k-C_n) - abs(C(j)-C(i)) = ' num2str(((k-C_n) - abs(C(j)-C(i))))])
%         test = (ones(1,((k-C_n) - abs(C(j)-C(i)))));
%         length(diag(ones(1,(k-C_n - abs(C(j)-C(i)))),C(j)-C(i)))
%         length(A)
        if((k-C_n) - abs(C(j)-C(i)) )>0 % axle n does influence strain
            A = A + axle_weights(i)*axle_weights(j)* diag(ones(1,k-C_n - abs((C(j)-C(i)))),C(j)-C(i));
        end
    end
end 
end

