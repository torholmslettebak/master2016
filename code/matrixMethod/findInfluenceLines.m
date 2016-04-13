function [  M_c, A, C ] = findInfluenceLines( strainHistory, TrainData)
% This method will find the influence lines for a given strain history
% This will be acomplished through Moses' equation
% The axle loads [A] are known, so the influence ordinates which minimises
% the following equation give best the best solution
% E = sum_from_k=1_to_k=numOfScans((M_k^M - M_k^T)^2)
% M_k^M = measured bending moment at scan k - measured response
% M_k^T = theoretical response
format long;
speed = TrainData.speed;
frequency = 1/TrainData.delta;
k = length(strainHistory);
n = length(TrainData.axleWeights);
C_n = round(sum(TrainData.axleDistances)*frequency/speed);
C = zeros(1,n);
% The matrix size

C(1) = 0;
for i = 1:n-1
        C(i+1) = round((sum(TrainData.axleDistances(1:i)))*frequency/speed);
end
% C = axleDistancesInSamples(TrainData);
% % Defining the matrix size 
if C(length(C)) > k
%    Extract the necessary parts of the C vector
    Cnew = C(C<k);
end
m = k-C(length(C));
M_c = zeros(m, 1);
for i = 1:m
    for j = 1:n
        M_c(i,1) = M_c(i,1) + TrainData.axleWeights(j)*strainHistory(i+C(j));
    end
end

% Now creating the A matrix, which depends on the axle weights
% The diagonal <-> sum of the squares of the axle weights
A = zeros(m, m);

for i = 1:n
    for j = i:n
%         disp(['i = ' num2str(i) ' j = ' num2str(j)]);
%         disp(['C(j) - C(i) = ' num2str(C(j) - C(i))]);
%         disp(['((k-C_n) - abs(C(j)-C(i)) = ' num2str(((k-C_n) - abs(C(j)-C(i))))])
%         test = (ones(1,((k-C_n) - abs(C(j)-C(i)))));
%         length(diag(ones(1,(k-C_n - abs(C(j)-C(i)))),C(j)-C(i)))
%         length(A)
        offset = C(j)-C(i);
        
        if((m) - abs(offset))>0 % axle n does influence strain
            oneVec = ones(1,m - abs(offset));
            diagonal = diag(oneVec,offset);
            A = A + TrainData.axleWeights(i)*TrainData.axleWeights(j)*diagonal;
        end
    end
end 
A = A + tril(transpose(A),-1);
end

