#!/usr/bin/env python
# coding: utf-8

# # QA: Parameter recovery
# Natalia Vélez, February 2022

import sys, re, os
import numpy as np
import pandas as pd
import teaching_models as teach
from os.path import join as opj

sys.path.append('..')
from utils import write_json, gsearch, str_extract

# Create output directory
out_dir = 'outputs/parameter_recovery'
print(f'Saving outputs to: {out_dir}')
os.makedirs(out_dir, exist_ok=True)

# Find files
sim_files = gsearch('outputs/simulated_data', '*.csv')
sim_files.sort()

print('Found %i files' % len(sim_files))

# Parse inputs
_, file_idx = sys.argv
file_idx = int(file_idx)
in_file = sim_files[file_idx]

print(f'Processing file #{file_idx}: {in_file}')

# Get ground truth values
pref = str_extract('(?<=pref=)[a-z]+', in_file)
weights = re.findall('(?<=w[A-z]{4}=)[0-9.]+', in_file)
weights = [float(f) for f in weights]
temp = str_extract('(?<=temp=)[0-9]+.[0-9]+', in_file)
print(f'Speaker preference: {pref}')
print(f'Weights: {weights}')
print(f'Temp: {temp}')

# Load simulated data:
sim_data = pd.read_csv(in_file)
sim_data = sim_data[sim_data.niter < 5] # number of replicates

print('Loading simulated data')
print(sim_data.shape)
print(sim_data.head())

# Find best-fitting parameter values for each iteration    

# prepare inputs
res_list = []
for idx, group in sim_data.groupby('niter'):
    param = {
        'args': {
            'data': group.drop(columns=['weight', 'temp', 'niter', 'label']).astype(int),
            'weights': np.array([None, None, None]),
            'pref_fun': teach.pref_dict[pref],
            'nIter': 20
        }
    }
    
    res = teach.model_optimize(pref, **param)
    res['label'] = pref
    res['weights'] = weights
    res['temp'] = float(temp)
    res['iter'] = idx
    res_list.append(res)
    
print(res_list)

# Save result to file
out_file = in_file.replace('simulated_data', 'parameter_recovery').replace('.csv', '.json')
print(f'Saving results to: {out_file}')
write_json(res_list, out_file)
print('Saving successful')