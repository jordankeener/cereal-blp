function [alpha_hat, beta_hat, sigma_hat, gmm_obj] = solve_model(p, x, z, s, mkt_ids)

    K = size(x,2);
    sigma0 = ones(K, 1);
    
    NS = 200;
    rng(48104);
    draws = normrnd(0, 1, K, NS);
    
    options = optimset('Display', 'iter', ...
        'PlotFcns', 'optimplotfval', ...
        'GradObj', 'off', ...
        'MaxIter', 1000, ...
        'MaxFunEvals', 10000, ...
        'TolFun', 1e-8, ...
        'TolX', 1e-5);
    
    
    lb = zeros(K, 1);
    ub = ones(K, 1) * 100;
    
    sigma_hat = fmincon(@(sigma) calc_objective(sigma, p, x, z, s, draws, mkt_ids), ...
        sigma0, [], [], [], [], lb, ub, [], options);
        
    [gmm_obj, alpha_hat, beta_hat] = calc_objective(sigma_hat, p, x, z, s, draws, mkt_ids);
end

