"""Fits the utility-maximizing model and a variety of lesioned models to human data

Usage:
    ./2_fit_model.py [sub] [m_idx]
    sub: unique subject identifier
    int between 1-30 (not including 3 or 17, which are excluded participants)
    
    m_idx: model index
    int between 0-6

Author:
    Natalia Vélez, March 2022
    Last updated April 2022
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
    # Pragmatic listener
    {'label': 'pragmatic_pref_cost', 'weights': [None, None, None], 'sampling_fun': teach.pedagogical_sampling}, # full model (pragmatic listener)
    {'label': 'pragmatic_cost', 'weights': [None, 0, None], 'sampling_fun': teach.pedagogical_sampling},
    {'label': 'pragmatic_pref', 'weights': [None, None, 0], 'sampling_fun': teach.pedagogical_sampling},
    {'label': 'pragmatic', 'weights': [None, 0, 0], 'sampling_fun': teach.pedagogical_sampling},
    
    # April 2022: Literal listener
    {'label': 'literal_pref_cost', 'weights': [None, None, None], 'sampling_fun': teach.strong_sampling}, # full model (literal listener)
    {'label': 'literal_cost', 'weights': [None, 0, None], 'sampling_fun': teach.strong_sampling},
    {'label': 'literal_pref', 'weights': [None, None, 0], 'sampling_fun': teach.strong_sampling},
    {'label': 'literal', 'weights': [None, 0, 0],  'sampling_fun': teach.strong_sampling},
    
    # Belief-free models
    # (We have to specify a sampling fun anyway, so I went with the fastest)
    {'label': 'pref_cost', 'weights': [0, None, None], 'sampling_fun': teach.strong_sampling}, # various lesioned models
    {'label': 'pref', 'weights': [0, None, 0], 'sampling_fun': teach.strong_sampling},
    {'label': 'cost', 'weights': [0, 0, None], 'sampling_fun': teach.strong_sampling},
]
print(f'{len(all_models)} models found')
model = all_models[m_idx]
print(f'Fitting model {model["label"]} to sub-{sub:02}')

# inputs to scipy.optimize
param = {
    'args': {
        'data': sub_data,
        'weights': np.array(model['weights']),
        'pref_fun': teach.edge_pref, # edge preference
        'sampling_fun': model['sampling_fun'],
        'nIter': 10
    }
}

# create output folders
out_dir = 'outputs/fit_model-%s_method-optimize/' % model['label']
print('Output directory: %s' % out_dir)
os.makedirs(out_dir, exist_ok=True)

# run model-fitting
res = teach.model_optimize('sub-%02d' % sub, **param)
res = {**res, **model} # combine with model info
del res['sampling_fun']

print('Result:')
print(res)

# save model-fitting results to file
out_file = opj(out_dir, 'sub-%02d_model-%s_method-optimize_result.json') % (sub, model['label'])
print('Saving results to: %s' % out_file)
write_json(res, out_file)