function [  M_c, A, C ] = findInfluenceLines( strainHistory, TrainData)
% This method will compute the necessary matrices and vectors for solving
% the system giving influence lines for a BWIM system
% This will be acomplished through Moses' equation
% The axle loads [A] are known, so the influence ordinates which minimises
% the following equation give best the best solution
% E = sum_from_k=1_to_k=numOfScans((M_k^M - M_k^T)^2)
% M_k^M = measured strain at scan k - measured response
% M_k^T = theoretical response
% TrainData is a matlab struct containg info of train speed, axle spacings
% and so on
% The returned variables: M_c =  a vector depending on axle weights and measured strain
% A = matrix depending only on axle spacing and axle weights
% C = axle distances in signal samples
format long;
speed = TrainData.speed;
frequency = 1/TrainData.delta;
k = length(strainHistory);
n = length(TrainData.axleWeights); % number of axles
C = zeros(1,n);
% The matrix size

C(1) = 0;
% calculates axle distances in signal samples, depending on sampling frequency and train speed
for i = 1:n-1
        C(i+1) = round((sum(TrainData.axleDistances(1:i)))*frequency/speed);
end
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
% The loop only calculates the upper triange of the matrix
A = zeros(m, m);

for i = 1:n
    for j = i:n
        offset = C(j)-C(i);
                if((m) - abs(offset))>0 % axle n does influence strain
            oneVec = ones(1,m - abs(offset));
            diagonal = diag(oneVec,offset);
            A = A + TrainData.axleWeights(i)*TrainData.axleWeights(j)*diagonal;
        end
    end
end 
% Form the full matrix through the transpose of the upper triangle
A = A + tril(transpose(A),-1);
end

