% calculates parameter estimates and SEs for model in problem set
%   - random coefs on X's only (sugar and mushy)
%   - identity weighting matrix (one-step GMM)
%   - no supply side


%% 1) data
addpath(genpath('./matlab/'));

clear 
system('python python/calc_instruments.py')
simdata = readtable('data/cereal_data_instruments.csv');

p = simdata.price;
x = [simdata.sugar, simdata.mushy, ones(size(p,1), 1)];
z = [simdata.z_rival_sugar, simdata.z_rival_mushy];
s = simdata.share;
mkt_ids = findgroups(simdata.year, simdata.quarter, simdata.city);

[alpha, beta, sigma, gmm_obj] = solve_model(p,x,z,s,mkt_ids)
