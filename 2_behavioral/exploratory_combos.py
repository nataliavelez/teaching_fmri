#!/usr/bin/env python
# coding: utf-8

# # Exploratory: Save dataframes of all possible combos
# Natalia Vélez, April 2022

import os
import pandas as pd
import numpy as np
import teaching_models as teach
from os.path import join as opj


# Helper function: Generate all combinations of three examples
def example_combos(prob_idx):
    
    # start blank dataframe
    tuples = [(i, j, k) for i in range(36) for j in range(i+1, 36) for k in range(j+1, 36)]
    index = pd.MultiIndex.from_tuples(tuples, names=['ex_0', 'ex_1', 'ex_2'])
    prob_df = pd.DataFrame(np.zeros((len(index), 4), dtype=int), columns=['A', 'B', 'C', 'D'])
    prob_df.index = index

    # check if each hypothesis contains combos
    truth_table = teach.problem_df(prob_idx)    
    for idx, row in prob_df.iterrows():
        try:
            prob_df.loc[idx] = (truth_table.loc[list(idx)].sum() == 3)*1
        except KeyError: # skip missing indices
            pass
        
    # drop impossible combinations
    prob_df = prob_df.loc[(prob_df.sum(axis=1) > 0), :]
    
    return prob_df

# Main loop: Generate all combos for each problem and save to file
out_dir = 'outputs/combos'
os.makedirs(out_dir, exist_ok=True)

for prob_idx in range(40):
    out_file = opj(out_dir, f'problem-{prob_idx:02}_combos.csv')
    prob_df = example_combos(prob_idx)
    
    prob_df.to_csv(out_file)


