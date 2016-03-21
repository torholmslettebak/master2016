function [ indArray ] = splitArray( len, n )
% splitArray:  This function takes the length of an array and the number of
% sub arrays the array is to be split into
% returns The indexes where the array is to split
% 
% len = 10;
% n = 3;
removed = 0;
indArray = zeros(1,n);
for i = 1:n
    splitVal = round((len-removed)/(n-i+1));
    indArray(i) = round(splitVal);
    removed = removed + splitVal;
end
% indArray
end

