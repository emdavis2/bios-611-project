from functions.acf_functions import *
from functions.compile_data_tracks_function import *
from functions.hetero_model_fitting_functions import *

import sys
import numpy as np
import pandas as pd

treatment = str(sys.argv[1])

min_track_length = int(sys.argv[2])

region = str(sys.argv[3])

time = int(sys.argv[4]) #5

dt = float(sys.argv[5]) #0.1667

Nwalkers = int(sys.argv[6]) #113

model_type = str(sys.argv[7]) #PRW or PRW_PB

err_fn = str(sys.argv[8]) #run_sim_get_velacf_err or run_sim_get_msd_err

tracks_region, tracks_geo_region, region_cells, region_endpointcells = compile_data_tracks(treatment, min_track_length, region)

#autocorrelation velocity for data
poslagaverage_data = []
for df in tracks_geo_region:
  track=df
  combined = pd.concat([track[['vx','vy']].reset_index(drop=True), track[['vx','vy']].reset_index(drop=True)], axis = 1 )
  poslagsmean, Nposlags, neglagsmean, Nneglags = xcorr_vector(combined, min_track_length)

  #remove nans here
  poslagsmean[np.isnan(poslagsmean)] = 0
  poslagaverage_data.append(poslagsmean)

#perform grid search
if model_type == 'PRW':
    std_dev_theta_vals = np.linspace(0.1, 2, 10)
    tot_err, std_dev_theta = perform_gridsearch_1param(poslagaverage_data, err_fn, std_dev_theta_vals, Nwalkers, dt, time, min_track_length)
    with open(r'hetero_model/model_params_{}_{}.txt'.format(region, model_type), 'w') as f:
        f.write('min_err={}'.format(str(tot_err)))
        f.write('\n')
        f.write('std_dev_theta={}'.format(str(std_dev_theta)))
elif model_type == 'PRW_PB':
    std_dev_w_vals = np.linspace(0.1, 2, 10)
    std_dev_theta_vals = np.linspace(0.1, 2, 10)
    tot_err, std_dev_w, std_dev_theta = perform_gridsearch_2params(poslagaverage_data, err_fn, std_dev_w_vals, std_dev_theta_vals, Nwalkers, dt, time, min_track_length)
    with open(r'hetero_model/model_params_{}_{}.txt'.format(region, model_type), 'w') as f:
        f.write('min_err={}'.format(str(tot_err)))
        f.write('\n')
        f.write('std_dev_w={}'.format(str(std_dev_w)))
        f.write('\n')
        f.write('std_dev_theta={}'.format(str(std_dev_theta)))

