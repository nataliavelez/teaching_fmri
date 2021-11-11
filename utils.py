import re,glob,json
from os.path import join as opj

def str_extract(pattern, s): return re.search(pattern,s).group(0)
def int_extract(pattern, s): return int(str_extract(pattern, s))
def gsearch(*args): return glob.glob(opj(*args))

def read_json(path):
    with open(path, 'r') as f:
        data = json.load(f)
        
    return data

def write_json(data, path):
    with open(path, 'w') as f:
        json.dump(data, f)