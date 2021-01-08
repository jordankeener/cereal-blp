import pandas as pd 
import numpy as np
import pyblp 


# replicate setup of model from estimate_hw_model.m
# linear chars: constant, sugar, mushy, price
# non-linear chars: constant, sugar, mushy
product_formulations = (pyblp.Formulation('1 + prices + sugar + mushy'),
                        pyblp.Formulation('1 + sugar + mushy'))


# calculate same instruments for price
mkt_id = ['city_ids', 'quarter']


# drop pre-made demand instruments
product_data=pd.read_csv(pyblp.data.NEVO_PRODUCTS_LOCATION)
product_data = product_data[product_data.columns.drop(list(product_data.filter(regex='demand_instruments')))]


# Hausman IVs
product_data['haus_sum'] = product_data.groupby(by = mkt_id)['prices'].transform('sum')
product_data['haus_N'] = product_data.groupby(by = mkt_id)['prices'].transform('count')
product_data['demand_instruments0'] = (product_data.haus_sum - product_data.prices) / (product_data.haus_N - 1)
product_data = product_data.drop(columns=['haus_sum', 'haus_N'])

print(product_data.isnull()['demand_instruments0'].sum())


# BLP-style rival chars IVs
firm_mkt = ['firm_ids'] + mkt_id 
chars = ['sugar', 'mushy']
blp_iv_rival = ['demand_instruments1','demand_instruments2']

product_data[blp_iv_rival] = (product_data.groupby(mkt_id)[chars].transform('sum') -        \
                    product_data.groupby(firm_mkt)[chars].transform('sum')) /     \
                   (product_data.groupby(mkt_id)[chars].transform('count') -      \
                    product_data.groupby(firm_mkt)[chars].transform('count'))
                       
print(product_data.isnull()[['demand_instruments1', 'demand_instruments2']].sum())


# setup model and solve
mc_integration = pyblp.Integration('monte_carlo', size=100, specification_options={'seed': 0})

problem = pyblp.Problem(product_formulations=product_formulations,
                        product_data=product_data,
                        integration=mc_integration)


sigma0 = np.eye(3)
bfgs = pyblp.Optimization('l-bfgs-b', {'gtol': 1e-6})

results = problem.solve(sigma=sigma0,
                        method='1s',
                        optimization=bfgs)
