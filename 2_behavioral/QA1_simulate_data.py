#!/usr/bin/env python
# coding: utf-8

# # QA: Simulate data from full model
# Natalia Vélez, February 2022

import os
import pandas as pd
import numpy as np
import teaching_models as teach
from tqdm import tqdm
from os.path import join as opj

# Create output directory
out_dir = 'outputs/simulated_data'
print(f'Creating output directory: {out_dir}')
os.makedirs(out_dir, exist_ok=True)

# simulation parameters 
weights = [
    [1./3, 1./3, 1./3], # even
    [1, 0, 0], # single-dimension agents
    [0, 1, 0],
    [0, 0, 1],
    [.2, .6, .2], # mixtures w/ one priority
    [.6, .2, .2],
    [.2, .2, .6],
    [.4, .4, .2], # mixtures with two priorities
    [.4, .2, .4],
    [.2, .4, .4]
]

prefs = {
    'edge': teach.edge_pref,
    'density': teach.density_pref,
    'typewriter': teach.typewriter_pref
}

temp = 2.5
niter = 25

# Main loop: Run simulation
print('Starting main simulation loop:')

for w in weights:
    
    print(f'==== {w} ====')
    
    # iterate over preference functions
    for label, pref_fun in prefs.items():
        
        print(f'Preference: {label}')
        sim_list = []
        
        # make several replicates for each combination of parameters
        for i in range(niter):
            iter_df = teach.simulate_dataset(i, pref_fun=pref_fun, weights=w, temp=temp, nIter=20)
            iter_df['label'] = label
            sim_list.append(iter_df)
        
        # output file
        out_file = opj(out_dir, f'simulation_pref={label}_wInfo={w[0]:.2f}_wPref={w[1]:.2f}_wCost={w[2]:.2f}_temp={temp}.csv')
        print(f'Saving simulated data to: {out_file}')
        
        # save simulation results to file
        sim_df = pd.concat(sim_list)
        sim_df[['niter', 'problem', 'cursor', 'example']] = sim_df[['niter', 'problem', 'cursor', 'example']].astype(int)
        print(sim_df.shape)
        print(sim_df.head())
        sim_df.to_csv(out_file, index=False)