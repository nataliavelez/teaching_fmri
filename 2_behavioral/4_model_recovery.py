#!/usr/bin/env python
# coding: utf-8

# # QA: Model recovery
# Natalia Vélez, March 2022

import sys, re, os
import numpy as np
import pandas as pd
import teaching_models as teach
from os.path import join as opj
from ast import literal_eval

sys.path.append('..')
from utils import write_json, gsearch, str_extract

# Create output directory
out_dir = 'outputs/model_recovery'
print('Saving outputs to: %s' % out_dir)
os.makedirs(out_dir, exist_ok=True)

# Find files
sim_files = gsearch('outputs/simulated_from_human', '*.csv')
sim_files.sort()

print('Found %i files' % len(sim_files))

# Define all models
all_models = [
    {'label': 'info_pref_cost', 'weights': np.array([None, None, None])}, # full model
    {'label': 'pref_cost', 'weights': np.array([0, None, None])}, # various lesioned models
    {'label': 'info_cost', 'weights': np.array([None, 0, None])},
    {'label': 'info_pref', 'weights': np.array([None, None, 0])},
    {'label': 'info', 'weights': np.array([None, 0, 0])},
    {'label': 'pref', 'weights': np.array([0, None, 0])},
    {'label': 'cost', 'weights': np.array([0, 0, None])},
]

# Parse inputs
_,m_idx,sub_idx=sys.argv
m_idx = int(m_idx)
sub_idx = int(sub_idx)
model = all_models[m_idx]
subject = 'sub-%02d' % sub_idx
in_file = 'outputs/simulated_from_human/simulated_data_model-%s.csv' % model['label']
print('Processing model #%i: %s' % (m_idx, in_file))
print('Processing data simulated from participant: %s' % subject)

# Load simulated data:
print('Loading simulated data...')
sim_data = pd.read_csv(in_file)
sim_data = sim_data[sim_data.subject == subject] # debug!
print(sim_data.shape)
print(sim_data.head())

# Iterate over models to compute model evidences
res_list = []

for alt_model in all_models:
    print('===== %s =====' % alt_model['label'])
    row = sim_data.iloc[0]
    param = {
        'args': {
            'data': sim_data[['problem', 'cursor', 'example']].copy().astype(int),
            'weights': alt_model['weights'],
            'pref_fun': teach.edge_pref,
            'nIter': 20
        }
    }

    res = teach.model_optimize('edge', **param)
    res['subject'] = subject
    res['true_model'] = model['label']
    res['true_weights'] = row['weight']
    res['fit_model'] = alt_model['label']

    res_list.append(res)

# Save result to file
out_file = opj(out_dir, f'recovery_{subject}_model-{model["label"]}.json')
print('Saving results to: %s' % out_file)
write_json(res_list, out_file)
print('Saving successful')

