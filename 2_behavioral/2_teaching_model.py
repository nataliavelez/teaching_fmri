#!/usr/bin/env python
# coding: utf-8

# # Fit teaching models to behavioral data
# Natalia Vélez & Alicia Chen, November 2021

import sys, pprint
import numpy as np
import pandas as pd
from ast import literal_eval as eval_tuple
from scipy.stats import entropy

sys.path.append('..')
from utils import read_json, write_json, int_extract


# Load teaching problems:
print('Loading teaching problems...')
problems = read_json('inputs/problems.json')
print(problems[0])


# Load exclusions:
print('\nLoading excluded participants...')
excluded = np.loadtxt('../1_preprocessing/outputs/excluded_participants.txt', dtype=str)
excluded = [int_extract('[0-9]+', s) for s in excluded]
print(excluded)


# Load teaching data:
def read_examples(e):
    coords = eval_tuple(e)
    idx = np.ravel_multi_index(coords, (6,6))
    
    return idx

print('\nLoading participant data...')
human_df = pd.read_csv('outputs/teaching_behavior.csv')
human_df = human_df.drop(columns=['onset', 'order', 'rating']) # drop columns that are irrelevant for model
human_df = human_df[~human_df.subject.isin(excluded)] # exclude wiggly participants
human_df = human_df[~pd.isna(human_df.example)] # exclude trials where teachers failed to respond
human_df['example'] = human_df.example.apply(read_examples)
print(human_df.shape)
print(human_df.head())


# ## Sampling methods

# Helper function: Convert problem into dataframe of coordinates x hypotheses
def problem_df(prob_idx):
    prob = problems[prob_idx]
    hypotheses = np.array(list(prob.values())) # read hypothesis space
    hypotheses_flat = np.reshape(hypotheses, (hypotheses.shape[0], hypotheses.shape[1]*hypotheses.shape[2])) #  flatten 3d => 2d array

    ### reshape into dataframe of coordinates x hypotheses
    df = pd.DataFrame(hypotheses_flat).stack().rename_axis(['hypothesis', 'idx']).reset_index(name='val')
    
    # name hypotheses
    df['hypothesis'] = pd.Categorical(df.hypothesis)
    df['hypothesis'] = df.hypothesis.cat.rename_categories(['A', 'B', 'C', 'D'])
    df['hypothesis'] = df['hypothesis'].astype('object')
    
    # spread each hypothesis into its own column
    df = df.pivot(index='idx', columns='hypothesis', values='val')
    df = df[df.sum(axis=1) > 0]
    
    return df


# Helper function: Returns a matrix of examples x hypotheses, where each entry indicates whether a given hypothesis is consistent with this next example *and all examples that came before it*
def filter_consistent_examples(prob_idx, past_examples=[]):
    example_space = problem_df(prob_idx)
    possible_examples = example_space.copy()
    
    for ex in past_examples:
        consistent_with_past = possible_examples.loc[ex] # which hypotheses did this hypothesis rule out?
        possible_examples = possible_examples.drop(ex) # drop past examples from consideration
        
        # drop hypotheses that are incompatible with this past example
        possible_examples = possible_examples.mul(consistent_with_past, axis=1)
        possible_examples = possible_examples[possible_examples.columns[possible_examples.sum()>0]]
        
    return possible_examples


# Helper function: Condition subsequent examples on past examples (used in pedagogical sampling predictions)
def condition_on_past(prob_idx, pH_0, past_examples):
    available_examples = filter_consistent_examples(prob_idx, past_examples)
    pH_conditional = available_examples.mul(pH_0)
    pH_conditional = pH_conditional.dropna(axis=0, how='all') # drop past examples
    pH_conditional = pH_conditional.dropna(axis=1, how='all') # drop hypotheses that are contradicted by past examples
    pH_conditional = pH_conditional.div(pH_conditional.sum(axis=1), axis=0) # re-normalize
    
    return pH_conditional


# Helper function: Return full belief distribution (used to generate model predictions)
def full_belief(nonzero_belief):
    belief = nonzero_belief.reindex(['A', 'B', 'C', 'D'], fill_value=0)
    return belief


# Helper function: Convert a pandas dataseries to a list of tuples containing `(index, value)` (we're going to use this to save model predictions to JSON files)
def series2tuple(s):
    return list(zip(s.index,s))


# ### a) Strong sampling

# Define the sampling method:

def strong_sampling(prob_idx, past_examples=[]):
    '''
    Input: Index of problem (as it appears in "problems" list)
    Output: Dataframe of the probability of selecting the data (idx), given the hypothesis (A, B, C, D)
    '''
    # find available examples
    available_examples = filter_consistent_examples(prob_idx, past_examples=past_examples)

    # select uniformly among available examples
    pD = available_examples.div(available_examples.sum(axis=0), axis=1)
    
    return pD


# Main method: Compute likelihood of data under strong sampling

def fit_strong_sampling(group):
    model_outputs = []
    examples = []
    
    # initialize belief distribution
    # (uniform prior over hypotheses)
    belief = np.ones(4)*.25
    belief_in_true = belief[0]
    
    for _, row in group.iterrows():
        ex = row.example
        # likelihood of observed data, assuming strong sampling
        strong_pD = strong_sampling(row.problem, past_examples=examples)
        out = row.copy()
        out['model'] = 'strong'
        out['lik'] = strong_pD['A'].loc[ex] # likelihood of selected example
        out['pD'] = series2tuple(strong_pD['A']) # full sampling distribution
        
        # learner's posterior belief given the data
        strong_pH = strong_pD.div(strong_pD.sum(axis=1), axis=0)
        new_belief = full_belief(strong_pH.loc[ex])
        out['pTrue'] = strong_pH['A'].loc[ex] # probability of true hypotheses
        out['pH'] = series2tuple(new_belief) # full belief distribution
        out['entropy'] = entropy(new_belief.values) # entropy of belief distribution
        
        # change in beliefs
        out['delta'] = new_belief['A'] - belief_in_true
        out['KL'] = entropy(new_belief.values, belief)
        belief = new_belief.values # change values for next round
        belief_in_true = belief[0]
        
        out = out.to_dict()
        examples.append(ex)
        model_outputs.append(out)
    
    return model_outputs


# Loop through behavioral data:
print('\nGenerating STRONG SAMPLING predictions...')
strong_predictions = []
for name, group in human_df.groupby(['subject', 'run', 'block_idx']):
    pred = fit_strong_sampling(group)
    strong_predictions += pred
    
pprint.pprint(strong_predictions[0])


# Save model predictions to file
print('Done! Saving to file.')
write_json(strong_predictions, 'outputs/model_predictions_strong.json')


# ### b) Pedagogical sampling

# Define the sampling method:
def pedagogical_sampling(prob_idx, past_examples=[], pH_0=None, nIter=100):
    
    # condition pH on past examples
    if len(past_examples):
        pH = condition_on_past(prob_idx, pH_0, past_examples)
    # else: start from a uniform prior
    else:
        hypothesis_space = problem_df(prob_idx)
        uniform_prior = hypothesis_space.div(hypothesis_space.sum(axis=1), axis=0)
        pH = uniform_prior
        
    # ~ recursive reasoning ~
    for _ in range(nIter):
        pD = pH.div(pH.sum(axis=0), axis=1)
        pH = pD.div(pD.sum(axis=1), axis=0)
        
    return pD, pH


# Main method: Compute likelihood of data under pedagogical sampling
def fit_pedagogical_sampling(group, nIter=20):
    model_outputs = []
    
    # initialize inputs to sampler
    examples = []
    pH = None
    
    # initialize belief distribution
    # (uniform prior over hypotheses)
    belief = np.ones(4)*.25
    belief_in_true = belief[0]
    
    for _, row in group.iterrows():
        ex = row.example
        out = row.copy()
        out['model'] = 'pedagogical'

        # likelihood of observed data, assuming pedagogical sampling
        pedagogical_pD, pH = pedagogical_sampling(row.problem, past_examples=examples, pH_0=pH, nIter=nIter)
        out['lik'] = pedagogical_pD['A'].loc[ex]
        out['pD'] = series2tuple(pedagogical_pD['A']) # full sampling distribution
        
        # learner's posterior belief given the data
        new_belief = full_belief(pH.loc[ex])
        out['pTrue'] = new_belief['A']
        out['pH'] = series2tuple(new_belief) # full belief distribution
        out['entropy'] = entropy(new_belief.values) # entropy of belief distribution
        
        # change in beliefs
        out['delta'] = new_belief['A'] - belief_in_true
        out['KL'] = entropy(new_belief.values, belief)
        belief = new_belief.values # change values for next round
        belief_in_true = belief[0]
        
        out = out.to_dict()
        examples.append(ex)
        model_outputs.append(out)
        
    return model_outputs


# Loop through behavioral data:
print('\nGenerating PEDAGOGICAL SAMPLING predictions...')
pedagogical_predictions = []
nIter=500
for name, group in human_df.groupby(['subject', 'run', 'block_idx']):
    pred = fit_pedagogical_sampling(group, nIter=nIter)
    pedagogical_predictions += pred
    
pprint.pprint(pedagogical_predictions[0])

# Save model_predictions to file
print('Done! Saving to file.')
write_json(pedagogical_predictions, 'outputs/model_predictions_pedagogical_n%i.json' % nIter)

