import os, sys
import numpy as np
import pandas as pd
from os.path import join as opj
import scipy.optimize, scipy.sparse
import teaching_models as teach
from tqdm import tqdm

sys.path.append('..')
from utils import write_json

## parse inputs
_, sub, model = sys.argv
sub = int(sub)

## load data and free parameters
sub_data = teach.human_df[(teach.human_df.subject == sub)].copy()
all_params = { # DEBUG: Utility-only
    'utility': {
        'x0': [0.5, 1], # weight, then temp
        'args': {
            'nIter': 20,
            'data': sub_data
        },
        'bounds': [(0,1), (0, None)]
    },
    'cost': {
        'x0': [1], # temp only
        'args': {
            'nIter': 1,
            'w': 0,
            'data': sub_data
        },
        'bounds': [(0, None)]
    },
    'pedagogical': {
        'x0': [0.5], # temp only
        'args': {
            'nIter': 20,
            'w': 1,
            'data': sub_data
        },
        'bounds': [(0, None)]
    }
}
param = all_params[model]

## create output folders
out_dir = 'outputs/fit_model-%s_method-optimize/' % model
os.makedirs(out_dir, exist_ok=True)

## main method: fit free parameters using scipy.optimize
# helper fun: returns -loglik
def eval_fit(x, args):
    '''Main function: Returns -loglik of data,
    given parameter settings
    '''
    inputs = {}
    if model == 'utility':
        inputs['w'], inputs['temp'] = x
    else:
        inputs['temp'] = x
    
    # merge with other args
    inputs = {**inputs, **args}
    
    # generate model predictions
    sub_predictions = []
    for prob, group in sub_data.groupby('problem'): # iterate through all teaching problems
        pred = teach.fit_utility_model(**inputs)
        pred = pd.DataFrame(pred)
        sub_predictions.append(pred)
        
    # calculate log likelihood
    sub_predictions = pd.concat(sub_predictions)
    sub_predictions['loglik'] = np.log(sub_predictions.lik)
    loglik = sub_predictions['loglik'].sum()
    
    return -loglik

# run model fitting
res = scipy.optimize.minimize(eval_fit, param['x0'], args=param['args'], bounds=param['bounds'], 
                              method='trust-constr', options={'disp': True})

## clean up and save outputs
def clean_outputs(v):
    '''Helper function: Cleans up outputs of res to make it easier to save
    '''
    
    if isinstance(v, list):
        # Critical! Cleans up lists recursively
        # (some fields have ndarrays nested inside lists)
        return [clean_outputs(v_i) for v_i in v]
    elif isinstance(v, np.ndarray):
        return v.tolist()
    elif isinstance(v, scipy.sparse.spmatrix):
        return v.todense().tolist()
    else:
        return v

print('Done with model fitting! Cleaning up outputs')
res_out = {k:clean_outputs(v) for k,v in res.items()}
print(res_out)

out_file = opj(out_dir, 'sub-%02d_model-%s_method-optimize_result.json') % (sub, model)
print('Saving results to: %s' % out_file)
write_json(res_out, out_file)