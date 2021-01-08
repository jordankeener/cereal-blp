% calculates parameter estimates and SEs for model in problem set
%   - random coefs on X's only (sugar and mushy plus a constant)
%   - one-step GMM with 2SLS weighting matrix (inv(Z'*Z))
%   - demand-side only, no supply
%   - IVs: Hausman instruments and BLP-sytle rival characteristics (within
%          market)


addpath(genpath('./matlab/'));

clear 
system('python python/calc_instruments.py')
simdata = readtable('data/cereal_data_instruments.csv');

p = simdata.price;
cons = ones(size(p,1), 1);
x = [simdata.sugar, simdata.mushy, cons];
z = [simdata.z_rival_sugar, simdata.z_rival_mushy, simdata.haus_iv];
s = simdata.share;
mkt_ids = findgroups(simdata.year, simdata.quarter, simdata.city);

[alpha, beta, sigma, gmm_obj] = solve_model(p, x, z, s, mkt_ids)
