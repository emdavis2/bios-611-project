from functions.compile_data_tracks_function import *

import ntpath
import os
import sys
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
#from scipy.stats import ttest_ind
from scipy.stats import f_oneway

treatment1 = str(sys.argv[1])

treatment2 = str(sys.argv[2])

min_track_length = int(sys.argv[3])

region1 = str(sys.argv[4])

region2 = str(sys.argv[5])

tracks_region1, tracks_geo_region1, region1_cells, region1_endpointcells = compile_data_tracks(treatment1, min_track_length, region1)

tracks_region2, tracks_geo_region2, region2_cells, region2_endpointcells = compile_data_tracks(treatment2, min_track_length, region2)

pixel_size = 1.5385 #pixels/micron

#clears out sentinel file if it exists
open('sentinels/cellshape_histogram.txt','w').close()
#create new sentinel file to write to
hist_boxplot_figs = open('sentinels/cellshape_histogram.txt','w')
file_lines = [] 

var_area_region1 = []
area_region1 = []
for df in tracks_geo_region1:
  area = df['area'].iloc[:,0]/(pixel_size**2)
  area_region1.append(area)
  var_area_region1.append(np.var(area))
plt.title('Variance of cell area over track in {}'.format(region1))
plt.hist(var_area_region1, bins=30)
plt.savefig('figures/cellshape_histogram/var_area_hist_{}.png'.format(region1))
plt.clf()
file_lines.append('figures/cellshape_histogram/var_area_hist_{}.png \n'.format(region1))
plt.title('Cell area over track in {}'.format(region1))
plt.hist(np.concatenate(area_region1).ravel(), bins=30)
plt.savefig('figures/cellshape_histogram/area_hist_{}.png'.format(region1))
plt.clf()
file_lines.append('figures/cellshape_histogram/area_hist_{}.png \n'.format(region1))

var_area_region2 = []
area_region2 = []
for df in tracks_geo_region2:
  area = df['area'].iloc[:,0]/(pixel_size**2)
  area_region2.append(area)
  var_area_region2.append(np.var(area))
plt.title('Variance of cell area over track on {}'.format(region2))
plt.hist(var_area_region2, bins=30)
plt.savefig('figures/cellshape_histogram/var_area_hist_{}.png'.format(region2))
plt.clf()
file_lines.append('figures/cellshape_histogram/var_area_hist_{}.png \n'.format(region2))
plt.title('Cell area over track in {}'.format(region2))
plt.hist(np.concatenate(area_region2).ravel(), bins=30)
plt.savefig('figures/cellshape_histogram/area_hist_{}.png'.format(region2))
plt.clf()
file_lines.append('figures/cellshape_histogram/area_hist_{}.png \n'.format(region2))

var_perim_region1 = []
perim_region1 = []
for df in tracks_geo_region1:
  perim = df['perimeter']/pixel_size
  perim_region1.append(perim)
  var_perim_region1.append(np.var(perim))
plt.title('Variance of cell perimeter over track on {}'.format(region1))
plt.hist(var_perim_region1, bins=30)
plt.savefig('figures/cellshape_histogram/var_perim_hist_{}.png'.format(region1))
plt.clf()
file_lines.append('figures/cellshape_histogram/var_perim_hist_{}.png \n'.format(region1))
plt.title('Cell perimeter over track on {}'.format(region1))
plt.hist(np.concatenate(perim_region1).ravel(), bins=30)
plt.savefig('figures/cellshape_histogram/perim_hist_{}.png'.format(region1))
plt.clf()
file_lines.append('figures/cellshape_histogram/perim_hist_{}.png \n'.format(region1))

var_perim_region2 = []
perim_region2 = []
for df in tracks_geo_region2:
  perim = df['perimeter']/pixel_size
  perim_region2.append(perim)
  var_perim_region2.append(np.var(perim))
plt.title('Variance of cell perimeter over track on {}'.format(region2))
plt.hist(var_perim_region2, bins=30)
plt.savefig('figures/cellshape_histogram/perim_hist_{}.png'.format(region2))
plt.clf()
file_lines.append('figures/cellshape_histogram/perim_hist_{}.png \n'.format(region2))
plt.title('Cell perimeter over track on {}'.format(region2))
plt.hist(np.concatenate(perim_region2).ravel(), bins=30)
plt.savefig('figures/cellshape_histogram/perim_hist_{}.png'.format(region2))
plt.clf()
file_lines.append('figures/cellshape_histogram/perim_hist_{}.png \n'.format(region2))