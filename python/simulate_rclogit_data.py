# simulating fake data for BLP estimation
# x: exogenous product characteristics
# p: endogenous price

import pandas as pd
import numpy as np

np.random.seed(46140)


# make skeleton of "micro" choice data
J = 10 # number of products
M = 10 # number of markets
N = 1000 # number of individuals per market


product_list = [i+1 for i in range(J)]
market_list = [i+1 for i in range(M)]
indv_list = [i+1 for i in range(N)]


index = pd.MultiIndex.from_product([product_list, market_list, indv_list], 
                                   names = ['prod_id', 'mkt_id', 'indv_id'])

df = pd.DataFrame(index = index).reset_index()


# simulate exogenous characteristics 

## x_j 
x1 = np.round(np.random.normal(10, 1.5, size = (J, 1)), decimals = 1)
x2 = np.random.randint(low=0, high=2, size = (J, 1))

prod_array = np.array([product_list]).T
prod_df = pd.DataFrame(np.concatenate((prod_array, x1, x2), axis=1), 
                       columns=['prod_id', 'x1', 'x2'])


## unobserved product quality (xi_jm)
xi = np.random.uniform(low = -1, high = 1, size = (J*M, 1))


# simulate prices
## function of own xi, rival x's in market, and random component

## create random component
log_p = np.random.normal(1.5, 0.3, size = (J*M, 1))
p_rand = np.exp(log_p)

mu_p = np.mean(p_rand)
sigma_p = np.std(p_rand)


market_array = np.array([market_list]).T
prod_mkt_array = np.dstack(np.meshgrid(prod_array, market_array)).reshape(-1,2)
prod_mkt_df = pd.DataFrame(np.concatenate((prod_mkt_array, xi, p_rand), axis=1),
                           columns=['prod_id', 'mkt_id', 'xi', 'p_rand'])


# simulate preference heterogeneity over x's
nu = np.random.normal(0, 1, size = (M*N, 3))

indv_array = np.array([indv_list]).T
indv_mkt_array = np.dstack(np.meshgrid(indv_array, market_array)).reshape(-1,2)
indv_mkt_df = pd.DataFrame(np.concatenate((indv_mkt_array, nu), axis=1),
                           columns=['indv_id', 'mkt_id', 'nu0', 'nu1', 'nu2'])

# simulate taste shocks
eps = np.random.gumbel(size = (J*M*N, 1))
eps_df = pd.DataFrame(eps, columns=['eps'])


# collect variables at different levels
df = pd.merge(df, prod_df, how = 'left', on = ['prod_id'])
df = pd.merge(df, prod_mkt_df, how = 'left', on = ['prod_id', 'mkt_id'])
df = pd.merge(df, indv_mkt_df, how = 'left', on = ['indv_id', 'mkt_id'])
df = pd.concat([df, eps_df], axis = 1)


# add endogenous/strategic price components (and instruments)
df['p'] = df.p_rand + 0.2 * (df.xi + 1)

    
df['haus_iv'] = (df.groupby('prod_id')['p_rand'].transform('sum') - df['p_rand']*N) /  \
    (df.groupby('prod_id')['p_rand'].transform('count') - N)

    
df['p'] = (1/2) * df.p + (1/2) * df.haus_iv 


# set parameters
alpha = 0.2
beta = [-1, 0.1, -0.25]
sigma = [0.3, 0.05, 0.1]


# calculate utility/choices
df['u'] = beta[0] + beta[1]*df.x1 + beta[2]*df.x2 - alpha*df.p + df.xi +  \
    sigma[0]*df.nu0 + sigma[1]*df.nu1*df.x1 + sigma[2]*df.nu2*df.x2 + df.eps 

df['max_u'] = df.groupby(['indv_id', 'mkt_id'])['u'].transform('max')
df = df.sort_values(['mkt_id', 'indv_id'])

df['oo_eps'] = np.random.gumbel(size = J*M*N)

df['choice'] = (df.u > df.oo_eps)*1 * (df.u >= df.max_u)*1


prod_mkt = ['prod_id', 'mkt_id']
aggvars = ['choice', 'p', 'x1', 'x2', 'haus_iv']
agg = pd.DataFrame(df.groupby(prod_mkt)[aggvars].mean())

agg = agg.rename(columns = {'choice':'share'})
agg['outshr'] = 1 - agg.groupby('mkt_id')['share'].transform('sum')


agg.to_csv('../data/simulated_rclogit_data_agg.csv')
df.to_csv('../data/simulated_rclogit_data_choice.csv')

