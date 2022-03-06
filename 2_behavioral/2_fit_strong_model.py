""" Fit strong sampling model
Natalia Vélez, January 2022

The strong-sampling model has no free parameters, so we have a separate method for fitting it!
"""

import os, sys
import numpy as np
import pandas as pd
from os.path import join as opj
import teaching_models as teach
from tqdm import tqdm

## parse inputs
_, sub = sys.argv
sub = int(sub)
model = 'strong' # holdover from an old grid-sampling script :)

# subject-specific data
sub_data = teach.human_df[(teach.human_df.subject == sub)].copy()

# simulation parameters
param = {
        'nIter': 1,
        'temp': [0],
        'weight': [0]
}

print('===== SUB-%02d =====' % sub)
print('MODEL: %s' % model)
print('\nSearch space:')
print('Weights:')
print(param['weight'])
print('Temperatures:')
print(param['temp'])
print('# recursive steps: %i' % param['nIter'])

## create output folders
out_dir = 'outputs/fit_model-%s_method-grid/' % model
os.makedirs(out_dir, exist_ok=True)
print('\nSaving outputs to: %s' % out_dir)

## main loop: exhaustively search parameter space
sub_predictions = []

for t in tqdm(param['temp']): # iterate over free parameter values
    for w in tqdm(param['weight'], desc='t=%0.1f' % t):
        for prob, group in sub_data.groupby('problem'): # generate predictions for each teaching problem
            
            pred = teach.fit_utility_model(group, nIter=param['nIter'], w = w, temp = t)
            pred = pd.DataFrame(pred)
            
            pred['model'] = model
            pred['temp'] = t
            pred['weight'] = w
            sub_predictions.append(pred)

## calculate likelihood of observed data
sub_predictions = pd.concat(sub_predictions) # calculate log-likelihoods
sub_predictions['loglik'] = np.log(sub_predictions.lik)

param_fits = sub_predictions.groupby(['model', 'temp', 'weight'])['loglik'].agg('sum').reset_index() # sum over trials
param_fits['subject'] = sub

## save winning predictions
out_f = opj(out_dir, 'sub-%02d_model-%s_method-grid_desc-predictions.csv' % (sub, model))
print('Done! Saving model predictions to: %s' % out_f)
sub_predictions.to_csv(out_f, index = False)
param_fits.to_csv(out_f.replace('predictions', 'params'), index = False)