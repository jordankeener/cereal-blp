function sim_shrs = sim_mkt_shrs(x, delta, sigma, draws)
% simulates market shares for a single market
%   overflow safe version
    [J,~] = size(x);
    [~, NS] = size(draws);
    
    % make J x NS matrix of numerator values for each product, sim
    signu = repmat(sigma, 1, NS) .* draws;
    Ujs = repmat(delta, 1, NS) + (x * signu);
    m = max(Ujs);
    
    num = exp(bsxfun(@minus, Ujs, m));
    
    % add accros products for denominator and and divide
    % then take average across simulations for each product
    sim_shrs = mean( bsxfun(@rdivide, num, exp(-m) + sum(num)) , 2);
   
end

