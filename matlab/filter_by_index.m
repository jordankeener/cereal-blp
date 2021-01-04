function filterlist = filter_by_index(varlist, indexlist, filterval)
% filters varlist to indexes where indexlist == filterval 
% {V(i){ for i \in {i : indexlist(i) == filterval}
    
    J = size(varlist, 2);
    
    if J == 1
        mask = indexlist == filterval;
        filterlist = varlist(mask);
    elseif  J > 1
        mask = indexlist == filterval;
        filterlist = [];
        for j = 1:J
           xj = varlist(:,j);
           fj = xj(mask);
           filterlist = [filterlist, fj];
        end
            
    end
    
end

