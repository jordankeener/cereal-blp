import pandas as pd
import numpy as np
import pyblp


product_data = pd.read_csv('data/fake_blp_data.csv')


product_formulations = (pyblp.Formulation('1 + prices + x1 + x2 + x3'),
                        pyblp.Formulation('1 + x1 + x2 + x3'))


mc_integration = pyblp.Integration('monte_carlo', size=200, specification_options={'seed': 0})

problem = pyblp.Problem(product_formulations=product_formulations,
                        product_data=product_data,
                        integration=mc_integration)


sigma0 = np.eye(4) / 2
bfgs = pyblp.Optimization('l-bfgs-b', {'gtol': 1e-8})

results = problem.solve(sigma=sigma0,
                        method='1s',
                        optimization=bfgs)
