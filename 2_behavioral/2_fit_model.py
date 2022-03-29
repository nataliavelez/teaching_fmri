"""Fits the utility-maximizing model and a variety of lesioned models to human data

Usage:
    ./2_fit_model.py [sub] [m_idx]
    sub: unique subject identifier
    int between 1-30 (not including 3 or 17, which are excluded participants)
    
    m_idx: model index
    int between 0-6

Author:
    Natalia Vélez, March 2022
"""

import os, sys
import numpy as np
import pandas as pd
from os.path import join as opj
import scipy.optimize, scipy.sparse
import teaching_models as teach
from tqdm import tqdm

sys.path.append('..')
from utils import write_json

# parse inputs
_, sub, m_idx = sys.argv
sub = int(sub)
m_idx = int(m_idx)

# load data and free parameters
sub_data = teach.human_df[(teach.human_df.subject == sub)].copy()

# select model for fitting
all_models = [
    {'label': 'info_pref_cost', 'weights': [None, None, None]}, # full model
    {'label': 'pref_cost', 'weights': [0, None, None]}, # various lesioned models
    {'label': 'info_cost', 'weights': [None, 0, None]},
    {'label': 'info_pref', 'weights': [None, None, 0]},
    {'label': 'info', 'weights': [None, 0, 0]},
    {'label': 'pref', 'weights': [0, None, 0]},
    {'label': 'cost', 'weights': [0, 0, None]},
]
model = all_models[m_idx] 

# inputs to scipy.optimize
param = {
    'args': {
        'data': sub_data,
        'weights': np.array(model['weights']),
        'pref_fun': teach.edge_pref, # edge preference
        'nIter': 20
    }
}

# create output folders
out_dir = 'outputs/fit_model-%s_method-optimize/' % model['label']
print('Output directory: %s' % out_dir)
os.makedirs(out_dir, exist_ok=True)

# run model-fitting
res = teach.model_optimize('sub-%02d' % sub, **param)
res = {**res, **model} # combine with model info

print('Result:')
print(res)

# save model-fitting results to file
out_file = opj(out_dir, 'sub-%02d_model-%s_method-optimize_result.json') % (sub, model['label'])
print('Saving results to: %s' % out_file)
write_json(res, out_file)