function [fval, alpha, beta] = calc_objective(lnsigma, p, x, z, s, draws, mkt_ids)
% calculates objective function value for given value of sigma
    
    sigma = exp(lnsigma);
    
    K = size(x,2);
    L = K + 1;
    
    % inversion to obtain mean utilities
    delta_init = zeros(size(p,1), 1);
    delta = inversion_contraction(delta_init, sigma, s, x, draws, mkt_ids);
    
    % IV regression of delta on (x,p) with z as instrument
    [gamma, res] = ivreg_2sls(delta, p, x, z);
    alpha = gamma(1);
    beta  = gamma(2:L, 1);
    
    % calculate GMM objective function for given sigma
    Z = [x, z];

    W = inv(Z'*Z);
    fval = (res' * Z) * W * (Z' * res);
end

