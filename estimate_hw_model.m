% calculates parameter estimates and SEs for model in problem set
%   - random coefs on X (sugar and mushy)
%   - identity matrix as weight


%% 1) data

clear 

system('python python/calc_instruments.py')
clear ans 

simdata = readtable('data/cereal_data_instruments.csv');
