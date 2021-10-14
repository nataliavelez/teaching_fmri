#!/bin/bash

DATA_DIR=/ncf/gershman/User/nvelezalicea/teaching/BIDS_data
singularity run docker://bids/validator $DATA_DIR --verbose