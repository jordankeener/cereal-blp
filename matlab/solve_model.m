function [alpha_hat, beta_hat, sigma_hat, gmm_obj] = solve_model(p, x, z, s, mkt_ids)

    K = size(x,2);
    lnsigma0 = ones(K, 1);
    
    % generate RC draws for x
    NS = 100;
    rng(48104);
    draws = normrnd(0, 1, K, NS);
    
    options = optimset('Display', 'iter', ...
        'PlotFcns', 'optimplotfval', ...
        'MaxIter', 100000, ...
        'MaxFunEvals', 100000, ...
        'TolX', 1e-3);
    
    lnsigma_hat = fminsearch(@(lnsigma) calc_objective(lnsigma, p, x, z, s, draws, mkt_ids), ...
        lnsigma0, options);
    sigma_hat = exp(lnsigma_hat);
    
    [gmm_obj, alpha_hat, beta_hat] = calc_objective(lnsigma_hat, p, x, z, s, draws, mkt_ids);
end
