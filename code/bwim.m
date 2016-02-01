
% Lengt of bridge [m]
L = 15;
% Number of sensors
n = 2;
% Distance between sensors
n_d = 5;
% Distane from reaction A to first sensor
L_a = 5;
% Distance from reaction A to furthest sensor
L_b = 10;




function generateInfluenceLines(L, n, n_d, L_a, L_b)
numberOfLines = n*2;
% generate functions for each line
% i = 1:numberOfLines;
maxA = L_a*(1-L_a/L);
maxB = L_b*(1-L_b/L);
line([0 0],[5 maxA]);
line([5 maxA],[15 0]);
end

generateInfluenceLines(L, n, n_d, L_a, L_b)