function sim_shrs = solve_all_mkt_shares(mkt_id_list, x, delta, sigma, draws)
% solves for the market shares (given mean utilities) 
% across markets in parallel 

    mkts = unique(mkt_id_list);
    [M,~] = size(mkts);
        
    parfor m = 1:M
       mkt_id = mkts(m); 
              
       mkt_delta = filter_by_index(delta, mkt_id_list, mkt_id);
       mkt_x = filter_by_index(x, mkt_id_list, mkt_id);
       
       part_shrs{m} = sim_mkt_shrs(mkt_x, mkt_delta, sigma, draws);
    end
    
    sim_shrs = real(cat(1,part_shrs{:}));
    
end

