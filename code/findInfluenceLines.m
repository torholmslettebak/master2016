function [  M_t ] = findInfluenceLines( axle_weights, strainHistory, axleDistances, speed )
% This method will find the influence lines for a given strain history
% This will be acomplished through Moses' equation
% The axle loads [A] are known, so the influence ordinates which minimises
% the following equation give best the best solution
% E = sum_from_k=1_to_k=numOfScans((M_k^M - M_k^T)^2)
% M_k^M = measured bending moment at scan k - measured response
% M_k^T = theoretical response

% M_k^t =
k = length(strainHistory);
n = length(axle_weights);
C_n = sum(axleDistances)*frequency/speed;
C = zeros(1,n);
for i = 1:n
    if i == 1
        % The number of scans corresponding to the axle distance L_i,
        % and L_i being the distance between axle i and the first axle.
        C(i) = 0;
    else
        C(i) = (sum(axleDistances(1:i)))*frequency/speed;
    end
end


M_t = zeros(k-C_n, 1);
for i = 1:k-C_n
    for j = 1:n
        if j == 1
            % The number of scans corresponding to the axle distance L_i,
            % and L_i being the distance between axle i and the first axle.
            C_i = 0;
        else
            C_i = (sum(axleDistances(1:j)))*frequency/speed;
        end
        M_t(i,1) = M_t(i,1) + axle_weights(j)*strainHistory(k+C_i);
    end
end
% Now creating the A matrix, which depends on the axle weights
% The diagonal <-> sum of the squares of the axle weights
A = zeros(k-C_n, k-C_n);
ADiag = 0;
off_diagonals_placed = 0;
off_diagonals = totalOffDiagonals(n); 
for axle = 1:length(axle_weights)
   ADiag = ADiag + axle_weights^2;
end
for m = 1:k-C_n
    for n = m:k-C_n
        if m == n
            A(m, n) = ADiag;
        elseif off_diagonals_placed<off_diagonals && 
%             Something something something darkside
            
            off_diagonals_placed = off_diagonals_placed + 1;
        else
            A(m,n) = 0;
            
    end
end
end

