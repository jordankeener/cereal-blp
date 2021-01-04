function [beta, res] = ivreg_2sls(y,x,z_incl,z_excl)
% estimates IV regression using 2SLS (no constant term)
% returns [beta_const, beta_x, beta_z_incl]

    [n, ~] = size(x);
    
    Z = [z_incl, z_excl];
    P_Z = Z / (Z'*Z) * Z';
    
    X = [x, z_incl];
    
    beta = (X' * P_Z * X) \ (X' * P_Z * y);
    res = y - X*beta;
end
