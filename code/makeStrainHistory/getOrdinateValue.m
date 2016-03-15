function y = getOrdinateValue(a,b,c,d, pos, L_a)
    if (pos<=L_a)
        y = a*pos + b;
    else
        y =c*(pos-L_a) + d;
    end
end	

