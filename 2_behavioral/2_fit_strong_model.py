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
model = 'strong'

# subject-specific data
sub_data = teach.human_df[(teach.human_df.subject == sub)].copy()

print('===== SUB-%02d =====' % sub)
print('MODEL: %s' % model)

## create output folders
out_dir = 'outputs/fit_model-%s_method-grid/' % model
os.makedirs(out_dir, exist_ok=True)
print('\nSaving outputs to: %s' % out_dir)

## main loop: exhaustively search parameter space
sub_predictions = []

for prob, group in sub_data.groupby('problem'): # generate predictions for each teaching problem

    pred = teach.utility_model_predictions(group, pref_fun=teach.edge_pref,
                                           weights=np.zeros(3), nIter=1)
    pred = pd.DataFrame(pred)

    pred['model'] = 'strong'
    pred['weights'] = [[0,0,0]]*group.shape[0]
    sub_predictions.append(pred)

## calculate likelihood of observed data
sub_predictions = pd.concat(sub_predictions) # calculate log-likelihoods
sub_predictions['loglik'] = np.log(sub_predictions.lik)

param_fits = sub_predictions.groupby(['model'])['loglik'].agg('sum').reset_index() # sum over trials
param_fits['subject'] = sub

## save winning predictions
out_f = opj(out_dir, 'sub-%02d_model-%s_method-grid_desc-predictions.csv' % (sub, model))
print('Done! Saving model predictions to: %s' % out_f)
sub_predictions.to_csv(out_f, index = False)
param_fits.to_csv(out_f.replace('predictions', 'params'), index = False)