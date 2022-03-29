#!/usr/bin/env python
# coding: utf-8

# # QA: Simulate data based on parameters fit to participants' data
# Natalia Vélez, March 2022

import os, sys
import pandas as pd
import numpy as np
import teaching_models as teach
from tqdm import tqdm
from os.path import join as opj

sys.path.append('..')
from utils import gsearch, read_json, str_extract

# Parse inputs
_, m_idx = sys.argv
m_idx = int(m_idx)

# Create output directory
out_dir = 'outputs/simulated_from_human'
print(f'Creating output directory: {out_dir}')
os.makedirs(out_dir, exist_ok=True)

# All models
all_models = [
    {'label': 'info_pref_cost', 'weights': np.array([None, None, None])}, # full model
    {'label': 'pref_cost', 'weights': np.array([0, None, None])}, # various lesioned models
    {'label': 'info_cost', 'weights': np.array([None, 0, None])},
    {'label': 'info_pref', 'weights': np.array([None, None, 0])},
    {'label': 'info', 'weights': np.array([None, 0, 0])},
    {'label': 'pref', 'weights': np.array([0, None, 0])},
    {'label': 'cost', 'weights': np.array([0, 0, None])},
]
model = all_models[m_idx]
print(f'Model: {model["label"]}')

# Load best-fitting model parameters:
param_files = gsearch(f'outputs/fit_model-{model["label"]}_method-optimize/*.json')
param_files.sort()

print(f'{len(param_files)} files found')
print(*param_files[:10], sep='\n')
print('...')

# read best-fitting parameter values
print('Retrieving best-fitting parameter values')
weight_list = []
for f in param_files:
    # get subject ID 
    sub_id = str_extract('sub-[0-9]{2}', f)
    
    # get best-fitting weights
    sub_res = read_json(f)
    fit_weights = sub_res['x']
    weights = model['weights'].copy()
    weights[weights == None] = fit_weights
    
    weight_list.append({'subject': sub_id, 'weights': weights})
    
print(*weight_list[:10], sep='\n')
print('...')


# simulate data using best-fitting weights
print('Simulating datasets...')
sim_list = []
for sub in weight_list:
    sub_df = teach.simulate_dataset(0, pref_fun=teach.edge_pref, weights=sub['weights'])
    sub_df['subject'] = sub['subject']
    sub_df['model'] = model['label']
    sim_list.append(sub_df)
    
# combine all simulated datasets
sim_df = pd.concat(sim_list)
print(sim_df.shape)
print(sim_df.head())

# save to file
out_f = opj(out_dir, f'simulated_data_model-{model["label"]}.csv')
print(f'Saving to: {out_f}')
sim_df.to_csv(out_f, index=False)

