.PHONY: clean
.PHONY: d3-vis
.PHONY: visualization
.PHONY: 

clean:
	rm -rf model
	rm -rf hetero_model
	rm -rf figures
	rm -rf sentinels
	rm -rf .created-dirs
	rm -f writeup.aux
	rm -f writeup.log
	rm -f writeup.pdf

.created-dirs:
	mkdir -p model
	mkdir -p hetero_model
	mkdir -p figures
	mkdir -p figures/acf_figures
	mkdir -p figures/histogram_boxplot
	mkdir -p figures/velacf_model
	mkdir -p figures/MSD_model
	mkdir -p figures/velacf_hetero_model
	mkdir -p figures/MSD_hetero_model
	mkdir -p figures/cellshape_histogram
	mkdir -p sentinels
	touch .created-dirs

# Create the autocorrelation figures for glass data
sentinels/ACF_figures_glass.txt: .created-dirs celltrack_data/glass_data\
 functions/acf_functions.py functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py
	python3.7 GenerateDataACF.py 'celltrack_data/glass_data' 30 'glass'

# Create the autocorrelation figures for gel data
sentinels/ACF_figures_stiff.txt: .created-dirs celltrack_data/gel_data\
 functions/acf_functions.py functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py
	python3.7 GenerateDataACF.py 'celltrack_data/gel_data' 30 'stiff'

# Create the boxplot and histogram figures for both glass and gel data
sentinels/histogram_boxplot.txt: .created-dirs celltrack_data/gel_data\
 celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py
	python3.7 GenerateDataHistogramBoxplot.py 'celltrack_data/glass_data' 'celltrack_data/gel_data' 30 'glass' 'stiff'

# Create the boxplot and histogram figures for both glass and gel data
sentinels/cellshape_histogram.txt: .created-dirs celltrack_data/gel_data\
 celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py
	python3.7 CellShapeOverTrack.py 'celltrack_data/glass_data' 'celltrack_data/gel_data' 30 'glass' 'stiff'

#Perform grid search to fit PRW model to glass data with vel acf
model/model_params_glass_LPRW_vel_acf.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/model_fitting_functions.py functions/langevin_PRW_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'LPRW' 'vel_acf' 'S' 10 50 20 'P' 0.5 5 20 0 0 0 0

#Perform grid search to fit PRW model to gel data with vel acf
model/model_params_stiff_LPRW_vel_acf.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/model_fitting_functions.py functions/langevin_PRW_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'LPRW' 'vel_acf' 'S' 10 50 20 'P' 0.5 5 20 0 0 0 0

#Perform grid search to fit PRW_polaritybias model to glass data with vel acf
model/model_params_glass_PRW_PB_vel_acf.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/model_fitting_functions.py functions/PRWpolaritybias_model_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'PRW_PB' 'vel_acf' 'std_dev_w' 0.2 0.9 10 'std_dev_theta' 0.9 1.5 10 0 0 0 0

#Perform grid search to fit PRW_polaritybias model to gel data with vel acf
model/model_params_stiff_PRW_PB_vel_acf.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/model_fitting_functions.py functions/PRWpolaritybias_model_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'PRW_PB' 'vel_acf' 'std_dev_w' 0.2 0.9 10 'std_dev_theta' 0.9 1.5 10 0 0 0 0

#Perform grid search to fit weighted_PRW model to glass data with vel acf
model/model_params_glass_weighted_PRW_vel_acf.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/model_fitting_functions.py functions/weighted_PRW_model_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'weighted_PRW' 'vel_acf' 'weight' 0 2 10 'kappa_w' 0 8 10 'kappa_theta' 0 8 10

#Perform grid search to fit weighted_PRW model to gel data with vel acf
model/model_params_stiff_weighted_PRW_vel_acf.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/model_fitting_functions.py functions/weighted_PRW_model_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'weighted_PRW' 'vel_acf' 'weight' 0 2 10 'kappa_w' 0 8 10 'kappa_theta' 0 8 10

#Perform grid search to fit PRW model to glass data with MSD
model/model_params_glass_LPRW_MSD.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/model_fitting_functions.py functions/langevin_PRW_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'LPRW' 'MSD' 'S' 10 50 20 'P' 0.5 5 20 0 0 0 0

#Perform grid search to fit PRW model to gel data with MSD
model/model_params_stiff_LPRW_MSD.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/model_fitting_functions.py functions/langevin_PRW_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'LPRW' 'MSD' 'S' 10 50 20 'P' 0.5 5 20 0 0 0 0

#Perform grid search to fit PRW_polaritybias model to glass data with MSD
model/model_params_glass_PRW_PB_MSD.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/model_fitting_functions.py functions/PRWpolaritybias_model_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'PRW_PB' 'MSD' 'std_dev_w' 0.2 0.9 10 'std_dev_theta' 0.9 1.5 10 0 0 0 0

#Perform grid search to fit PRW_polaritybias model to gel data with MSD
model/model_params_stiff_PRW_PB_MSD.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/model_fitting_functions.py functions/PRWpolaritybias_model_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'PRW_PB' 'MSD' 'std_dev_w' 0.2 0.9 10 'std_dev_theta' 0.9 1.5 10 0 0 0 0

#Perform grid search to fit weighted_PRW model to glass data with MSD
model/model_params_glass_weighted_PRW_MSD.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/model_fitting_functions.py functions/weighted_PRW_model_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'weighted_PRW' 'MSD' 'weight' 0 2 10 'kappa_w' 0 8 10 'kappa_theta' 0 8 10

#Perform grid search to fit weighted_PRW model to gel data with MSD
model/model_params_stiff_weighted_PRW_MSD.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/model_fitting_functions.py functions/weighted_PRW_model_functions.py
	python3.7 RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'weighted_PRW' 'MSD' 'weight' 0 2 10 'kappa_w' 0 8 10 'kappa_theta' 0 8 10

#Make figures comparing models with optimal parameters to glass data using vel_acf fitting metric
sentinels/figs_velacf_model_glass.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/msd_functions.py functions/PRWpolaritybias_model_functions.py functions/weighted_PRW_model_functions.py functions/PRW_model_functions.py functions/langevin_PRW_functions.py\
 functions/model_fitting_functions.py model/model_params_glass_LPRW_vel_acf.txt model/model_params_glass_PRW_PB_vel_acf.txt model/model_params_glass_weighted_PRW_vel_acf.txt
	python3.7 CompareModelAndData.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'model/model_params_glass_LPRW_vel_acf.txt' 'model/model_params_glass_PRW_PB_vel_acf.txt' 'model/model_params_glass_weighted_PRW_vel_acf.txt' 'figures/velacf_model/'

#Make figures comparing models with optimal parameters to gel data using vel_acf fitting metric
sentinels/figs_velacf_model_stiff.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/msd_functions.py functions/PRWpolaritybias_model_functions.py functions/weighted_PRW_model_functions.py functions/PRW_model_functions.py functions/langevin_PRW_functions.py\
 functions/model_fitting_functions.py model/model_params_stiff_LPRW_vel_acf.txt model/model_params_stiff_PRW_PB_vel_acf.txt model/model_params_stiff_weighted_PRW_vel_acf.txt
	python3.7 CompareModelAndData.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'model/model_params_stiff_LPRW_vel_acf.txt' 'model/model_params_stiff_PRW_PB_vel_acf.txt' 'model/model_params_stiff_weighted_PRW_vel_acf.txt' 'figures/velacf_model/'

#Make figures comparing models with optimal parameters to glass data using MSD fitting metric
sentinels/figs_MSD_model_glass.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/msd_functions.py functions/PRWpolaritybias_model_functions.py functions/weighted_PRW_model_functions.py functions/PRW_model_functions.py functions/langevin_PRW_functions.py\
 functions/model_fitting_functions.py model/model_params_glass_LPRW_MSD.txt model/model_params_glass_PRW_PB_MSD.txt model/model_params_glass_weighted_PRW_MSD.txt
	python3.7 CompareModelAndData.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'model/model_params_glass_LPRW_MSD.txt' 'model/model_params_glass_PRW_PB_MSD.txt' 'model/model_params_glass_weighted_PRW_MSD.txt' 'figures/MSD_model/'

#Make figures comparing models with optimal parameters to gel data using MSD fitting metric
sentinels/figs_MSD_model_stiff.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/msd_functions.py functions/PRWpolaritybias_model_functions.py functions/weighted_PRW_model_functions.py functions/PRW_model_functions.py functions/langevin_PRW_functions.py\
 functions/model_fitting_functions.py model/model_params_stiff_LPRW_MSD.txt model/model_params_stiff_PRW_PB_MSD.txt model/model_params_stiff_weighted_PRW_MSD.txt
	python3.7 CompareModelAndData.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'model/model_params_stiff_LPRW_MSD.txt' 'model/model_params_stiff_PRW_PB_MSD.txt' 'model/model_params_stiff_weighted_PRW_MSD.txt' 'figures/MSD_model/'

#Perform grid search to fit heterogeneous PRW model to glass data with vel acf
hetero_model/model_params_glass_LPRW_vel_acf.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/hetero_model_fitting_functions.py functions/langevin_PRW_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'LPRW' 'vel_acf' 'S' 10 50 10 'P' 0.5 5 10 0 0 0 0

#Perform grid search to fit heterogeneous PRW model to gel data with vel acf
hetero_model/model_params_stiff_LPRW_vel_acf.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/hetero_model_fitting_functions.py functions/langevin_PRW_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'LPRW' 'vel_acf' 'S' 10 50 10 'P' 0.5 5 10 0 0 0 0

#Perform grid search to fit heterogeneous PRW_polaritybias model to glass data with vel acf
hetero_model/model_params_glass_PRW_PB_vel_acf.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/hetero_model_fitting_functions.py functions/PRWpolaritybias_model_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'PRW_PB' 'vel_acf' 'std_dev_w' 0.1 2 10 'std_dev_theta' 0.1 2 10 0 0 0 0

#Perform grid search to fit heterogeneous PRW_polaritybias model to gel data with vel acf
hetero_model/model_params_stiff_PRW_PB_vel_acf.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/hetero_model_fitting_functions.py functions/PRWpolaritybias_model_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'PRW_PB' 'vel_acf' 'std_dev_w' 0.1 2 10 'std_dev_theta' 0.1 2 10 0 0 0 0

#Perform grid search to fit heterogeneous weighted_PRW model to glass data with vel acf
hetero_model/model_params_glass_weighted_PRW_vel_acf.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/hetero_model_fitting_functions.py functions/weighted_PRW_model_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'weighted_PRW' 'vel_acf' 'weight' 0 2 10 'kappa_w' 0 8 10 'kappa_theta' 0 8 10

#Perform grid search to fit heterogeneous weighted_PRW model to gel data with vel acf
hetero_model/model_params_stiff_weighted_PRW_vel_acf.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/hetero_model_fitting_functions.py functions/weighted_PRW_model_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'weighted_PRW' 'vel_acf' 'weight' 0 2 10 'kappa_w' 0 8 10 'kappa_theta' 0 8 10

#Perform grid search to fit heterogeneous PRW model to glass data with MSD
hetero_model/model_params_glass_LPRW_MSD.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/hetero_model_fitting_functions.py functions/langevin_PRW_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'LPRW' 'MSD' 'S' 10 50 10 'P' 0.5 5 10 0 0 0 0

#Perform grid search to fit heterogeneous PRW model to gel data with MSD
hetero_model/model_params_stiff_LPRW_MSD.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/hetero_model_fitting_functions.py functions/langevin_PRW_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'LPRW' 'MSD' 'S' 10 50 10 'P' 0.5 5 10 0 0 0 0

#Perform grid search to fit heterogeneous PRW_polaritybias model to glass data with MSD
hetero_model/model_params_glass_PRW_PB_MSD.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/hetero_model_fitting_functions.py functions/PRWpolaritybias_model_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'PRW_PB' 'MSD' 'std_dev_w' 0.1 2 10 'std_dev_theta' 0.1 2 10 0 0 0 0

#Perform grid search to fit heterogeneous PRW_polaritybias model to gel data with MSD
hetero_model/model_params_stiff_PRW_PB_MSD.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/hetero_model_fitting_functions.py functions/PRWpolaritybias_model_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'PRW_PB' 'MSD' 'std_dev_w' 0.1 2 10 'std_dev_theta' 0.1 2 10 0 0 0 0

#Perform grid search to fit heterogeneous weighted_PRW model to glass data with MSD
hetero_model/model_params_glass_weighted_PRW_MSD.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/hetero_model_fitting_functions.py functions/weighted_PRW_model_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'weighted_PRW' 'MSD' 'weight' 0 2 10 'kappa_w' 0 8 10 'kappa_theta' 0 8 10

#Perform grid search to fit heterogeneous weighted_PRW model to gel data with MSD
hetero_model/model_params_stiff_weighted_PRW_MSD.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/msd_functions.py functions/hetero_model_fitting_functions.py functions/weighted_PRW_model_functions.py
	python3.7 Hetero_RunGridSearchFitModel.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'weighted_PRW' 'MSD' 'weight' 0 2 10 'kappa_w' 0 8 10 'kappa_theta' 0 8 10

#Make figures comparing heterogeneous models with optimal parameters to glass data using vel_acf fitting metric
sentinels/figs_velacf_hetero_model_glass.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/msd_functions.py functions/PRWpolaritybias_model_functions.py functions/weighted_PRW_model_functions.py functions/PRW_model_functions.py functions/langevin_PRW_functions.py\
 functions/model_fitting_functions.py hetero_model/model_params_glass_LPRW_vel_acf.txt hetero_model/model_params_glass_PRW_PB_vel_acf.txt hetero_model/model_params_glass_weighted_PRW_vel_acf.txt
	python3.7 Hetero_CompareModelAndData.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'hetero_model/model_params_glass_LPRW_vel_acf.txt' 'hetero_model/model_params_glass_PRW_PB_vel_acf.txt' 'hetero_model/model_params_glass_weighted_PRW_vel_acf.txt' 'figures/velacf_hetero_model/'

#Make figures comparing heterogeneous models with optimal parameters to gel data using vel_acf fitting metric
sentinels/figs_velacf_hetero_model_stiff.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/msd_functions.py functions/PRWpolaritybias_model_functions.py functions/weighted_PRW_model_functions.py functions/PRW_model_functions.py functions/langevin_PRW_functions.py\
 functions/model_fitting_functions.py hetero_model/model_params_stiff_LPRW_vel_acf.txt hetero_model/model_params_stiff_PRW_PB_vel_acf.txt hetero_model/model_params_stiff_weighted_PRW_vel_acf.txt
	python3.7 Hetero_CompareModelAndData.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'hetero_model/model_params_stiff_LPRW_vel_acf.txt' 'hetero_model/model_params_stiff_PRW_PB_vel_acf.txt' 'hetero_model/model_params_stiff_weighted_PRW_vel_acf.txt' 'figures/velacf_hetero_model/'

#Make figures comparing heterogeneous models with optimal parameters to glass data using MSD fitting metric
sentinels/figs_MSD_hetero_model_glass.txt: .created-dirs celltrack_data/glass_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/msd_functions.py functions/PRWpolaritybias_model_functions.py functions/weighted_PRW_model_functions.py functions/PRW_model_functions.py functions/langevin_PRW_functions.py\
 functions/model_fitting_functions.py hetero_model/model_params_glass_LPRW_MSD.txt hetero_model/model_params_glass_PRW_PB_MSD.txt hetero_model/model_params_glass_weighted_PRW_MSD.txt
	python3.7 Hetero_CompareModelAndData.py 'celltrack_data/glass_data' 30 'glass' 5 0.1667 113 'hetero_model/model_params_glass_LPRW_MSD.txt' 'hetero_model/model_params_glass_PRW_PB_MSD.txt' 'hetero_model/model_params_glass_weighted_PRW_MSD.txt' 'figures/MSD_hetero_model/'

#Make figures comparing heterogeneous models with optimal parameters to gel data using MSD fitting metric
sentinels/figs_MSD_hetero_model_stiff.txt: .created-dirs celltrack_data/gel_data functions/compile_data_tracks_function.py\
 functions/libraries/track_functions.py functions/libraries/qc_functions.py\
 functions/libraries/filter_cells_fns.py functions/libraries/centers.py\
 functions/acf_functions.py functions/msd_functions.py functions/PRWpolaritybias_model_functions.py functions/weighted_PRW_model_functions.py functions/PRW_model_functions.py functions/langevin_PRW_functions.py\
 functions/model_fitting_functions.py hetero_model/model_params_stiff_LPRW_MSD.txt hetero_model/model_params_stiff_PRW_PB_MSD.txt hetero_model/model_params_stiff_weighted_PRW_MSD.txt
	python3.7 Hetero_CompareModelAndData.py 'celltrack_data/gel_data' 30 'stiff' 5 0.1667 119 'hetero_model/model_params_stiff_LPRW_MSD.txt' 'hetero_model/model_params_stiff_PRW_PB_MSD.txt' 'hetero_model/model_params_stiff_weighted_PRW_MSD.txt' 'figures/MSD_hetero_model/'

# Build the final report for the project.
writeup.pdf: .created-dirs sentinels/ACF_figures_glass.txt sentinels/ACF_figures_stiff.txt sentinels/histogram_boxplot.txt\
 sentinels/figs_velacf_model_glass.txt sentinels/figs_velacf_model_stiff.txt sentinels/figs_MSD_model_glass.txt sentinels/figs_MSD_model_stiff.txt\
 sentinels/figs_velacf_hetero_model_glass.txt sentinels/figs_velacf_hetero_model_stiff.txt sentinels/figs_MSD_hetero_model_glass.txt\
 sentinels/figs_MSD_hetero_model_stiff.txt
	pdflatex writeup.tex
