function [ influencematrix ] = genInflMatFromCalcInflLine( Infl, numberOfaxles, C )
%GENINFLMATFROMCALCINFLLINE Summary of this function goes here
%   Detailed explanation goes here
influencematrix = zeros(length(Infl+C(length(C))), numberOfaxles);
for i = 1:numberOfaxles
    counter = C(i);
    for j = 1:length(Infl)
        influencematrix(counter+j, i) = Infl(j);
    end
end

