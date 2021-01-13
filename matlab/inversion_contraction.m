function delta = inversion_contraction(d0, sigma, s, x, draws, mkt_ids)
% computes mean utilities given sigma using BLP contraction mapping
    
    max_iter  = 2000;
    tol = 2e-14;
    error = tol + 1;
    iter = 0;
    
    while(tol < error && iter < max_iter)
        iter = iter + 1;
        sim_s = solve_all_mkt_shares(mkt_ids, x, d0, sigma, draws);
        d1 = d0 + log(s) - log(sim_s);
        error = max(abs(d1 - d0));
        d0 = d1;
    end
    
    delta = d1;
end

