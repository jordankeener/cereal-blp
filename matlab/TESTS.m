% function tests 

%% ivreg_2sls ------------------------------------------------------------

clear 
simdata = readtable('../data/cereal_data_instruments.csv');

y = simdata.delta_logit;
x = simdata.price;
z_incl = [simdata.sugar, simdata.mushy];
z_excl = [simdata.haus_iv, simdata.z_rival_sugar, simdata.z_rival_mushy];

[coefs, res] = ivreg_2sls(y, x, z_incl, z_excl);


%% solve_all_mkt_shares.m ------------------------------------------------

clear 
simdata = generatedata(1000);


p = simdata.p;
x = simdata.x(:, 1:4);
z = simdata.Z(:, 5:end);
s = simdata.sjt;
mkt_ids = simdata.mktid;

K = size(x,2);
lnsigma = zeros(K, 1);

NS = 100;
rng(48104);
draws = normrnd(0, 1, K, NS);

sigma = exp(lnsigma);
    
K = size(x,2);
L = K + 1;

delta_init = zeros(size(p,1), 1);

sim_s = solve_all_mkt_shares(mkt_ids, x, delta_init, sigma, draws);


%% inversion_contractilon ------------------------------------------------

clear 
simdata = generatedata(1000);


p = simdata.p;
x = simdata.x(:, 1:4);
z = simdata.Z(:, 5:end);
s = simdata.sjt;
mkt_ids = simdata.mktid;

K = size(x,2);
lnsigma = zeros(K, 1);

NS = 100;
rng(48104);
draws = normrnd(0, 1, K, NS);

sigma = exp(lnsigma);
    
K = size(x,2);
L = K + 1;

delta_init = zeros(size(p,1), 1);

delta = inversion_contraction(delta_init, sigma, s, x, draws, mkt_ids);


%% calc_objective --------------------------------------------------------

clear 
simdata = generatedata(1000);


p = simdata.p;
x = simdata.x(:, 1:4);
z = simdata.Z(:, 5:end);
s = simdata.sjt;
mkt_ids = simdata.mktid;

K = size(x,2);
sigma = ones(K, 1);

NS = 100;
rng(48104);
draws = normrnd(0, 1, K, NS);

[fval, alpha, beta] = calc_objective(sigma, p, x, z, s, draws, mkt_ids)


