function [ vector ] = removeZeroIndexesFromEnd( vector )
%REMOVEZEROINDEXESFROMEND: removes indexes containing exactly zero values
%from ending of vector
vector(length(vector))
if(vector(length(vector))==0)
    index = length(vector);
    value = 0;
    while (value == 0)
       value = vector(index);
       index = index - 1;
    end
    vector = vector(1:index);
end

end

