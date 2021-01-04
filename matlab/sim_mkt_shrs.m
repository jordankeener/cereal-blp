function sim_shrs = sim_mkt_shrs(x, delta, sigma, draws)
% simulates market shares for a single market

    [J,~] = size(x);
    [~, NS] = size(draws);
    
    % create J x NS matrix exp(delta_j + random coefs) for each prod, sim
    signu = repmat(sigma, 1, NS) .* draws;
    num = exp(repmat(delta, 1, NS) + (x * signu));
    
    % create and repeat denominator in expression 
    den = repmat(1 + sum(num), J, 1);
    
    % divide element-wise and average across simulations
    sim_shrs = mean(num ./ den, 2);
end

