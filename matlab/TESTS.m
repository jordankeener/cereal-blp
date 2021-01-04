% function tests 

%% ivreg_2sls ------------------------------------------------------------

clear 
simdata = readtable('../data/cereal_data_instruments.csv');

y = simdata.delta_logit;
x = simdata.price;
z_incl = [simdata.sugar, simdata.mushy];
z_excl = [simdata.haus_iv, simdata.z_rival_sugar, simdata.z_rival_mushy];

[coefs, res] = ivreg_2sls(y, x, z_incl, z_excl);


%% solve_model -----------------------------------------------------------
clear 
simdata = readtable('../data/cereal_data_instruments.csv');

p = simdata.price;
x = [simdata.sugar, simdata.mushy, ones(size(p,1), 1)];
z = [simdata.z_rival_sugar, simdata.z_rival_mushy];
s = simdata.share;
mkt_ids = findgroups(simdata.year, simdata.quarter, simdata.city);

[alpha, beta, sigma, gmm_obj] = solve_model(p,x,z,s,mkt_ids)
