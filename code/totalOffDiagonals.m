function [ offDiags ] = totalOffDiagonals(n)
% Sums the off diagonals in axle matrices
offDiags = 0;
for i = 1:n
    offDiags = offDiags + n - i;
end
end

