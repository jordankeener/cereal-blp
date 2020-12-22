import pandas as pd
import numpy as np


datadir = 'data/'

# simulated cereal sales dataset
df = pd.read_csv(datadir + 'cereal_data.csv')


mkt_id = ['city', 'year', 'quarter']

print("Count observations:")
print(df.count())
print("Check missingness:")
print(df.isnull().sum())


# calculate outside good share for each market
outshr_by_mkt = pd.DataFrame(df.groupby(by = mkt_id)['share'].sum())
outshr_by_mkt['share'] = 1 - outshr_by_mkt.share
outshr_by_mkt = outshr_by_mkt.rename(columns = {'share':'outshare'})

# merge outside good share to product-level data
df = pd.merge(df, outshr_by_mkt, how = 'left', on = mkt_id)


# calculate market-level average characteristics (without merging back in)
df[['mkt_mean_sugar', 'mkt_mean_mushy']] = df.groupby(by = mkt_id)[['sugar', 'mushy']].transform('mean')


# create BLP style instruments
firm_mkt = ['firm_id'] + mkt_id 
chars = ['sugar', 'mushy']
blp_iv_rival = ['z_rival_sugar','z_rival_mushy']

df[blp_iv_rival] = (df.groupby(mkt_id)[chars].transform('sum') -        \
                    df.groupby(firm_mkt)[chars].transform('sum')) /     \
                   (df.groupby(mkt_id)[chars].transform('count') -      \
                    df.groupby(firm_mkt)[chars].transform('count'))


# create Hausman instruments
df['haus_sum'] = df.groupby(by = mkt_id)['price'].transform('sum')
df['haus_N'] = df.groupby(by = mkt_id)['price'].transform('count')
df['haus_iv'] = (df.haus_sum - df.price) / (df.haus_N - 1)

print('Check for missing instruments:')
print(df.isnull()[['haus_iv'] + blp_iv_rival].sum())
df = df.drop(columns=['haus_sum', 'haus_N'])


# calculate logit mean utilities
df['delta_logit'] = np.log(df.share) - np.log(df.outshare)


# save full data with instruments/other variables added 
df.to_csv(datadir + 'cereal_data_instruments.csv', index=False)
