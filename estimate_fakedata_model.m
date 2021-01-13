% estimate model on simulated BLP data

addpath(genpath('./matlab/'));

clear 
simdata = generatedata(100000);

p = simdata.p;
x = simdata.x(:, 1:4);
z = simdata.Z(:, 5:end);
s = simdata.sjt;
mkt_ids = simdata.mktid;

dt = table(mkt_ids, p, s, x(:,2), x(:,3), x(:,4), ...
    z(:,1), z(:,2), z(:,3), z(:,4), z(:,5), z(:,6));

dt.Properties.VariableNames = {'market_ids' 'prices' 'shares' 'x1' 'x2' 'x3' ...
    'demand_instruments0' 'demand_instruments1' 'demand_instruments2' ...
    'demand_instruments3' 'demand_instruments4' 'demand_instruments5'};

writetable(dt, 'data/fake_blp_data.csv')


[alpha, beta, sigma, gmm_obj] = solve_model(p, x, z, s, mkt_ids)
