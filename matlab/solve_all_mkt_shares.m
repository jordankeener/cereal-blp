function sim_shrs = solve_all_mkt_shares(mkt_id_list, x, delta, sigma, draws)
    
    mkts = unique(mkt_id_list);
    [M,~] = size(mkts);
    
    iter_shrs = [];
    
    for m = 1:M
       mkt_id = mkts(m); 
              
       mkt_delta = filter_by_index(delta, mkt_id_list, mkt_id);
       mkt_x = filter_by_index(x, mkt_id_list, mkt_id);
       
       mkt_sim_shrs = sim_mkt_shrs(mkt_x, mkt_delta, sigma, draws);
       iter_shrs = [iter_shrs ; mkt_sim_shrs];
    end
    
    sim_shrs = iter_shrs;
    
end

