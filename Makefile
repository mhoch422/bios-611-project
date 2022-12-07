.PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data
	rm -rf writeup.pdf
	rm -rf model_data
	rm -rf RPlots.pdf

.created-dirs:
	mkdir -p figures
	mkdir -p derived_data
	mkdir -p model_data

derived_data/stop_info.csv\
 derived_data/municipality_stops.csv\
 derived_data/fin_info.csv\
 derived_data/boston_stop_info.csv\
 derived_data/boston_demo.csv\
 derived_data/municipality_stops_NoBoston.csv: preprocess.R\
 source_data/Boston_Neighborhoods.geojson\
 source_data/Boston_Neighborhoods_tables.xlsm\
 source_data/Bus_Stops.csv\
 source_data/RT_stops.csv\
 source_data/population.csv
	Rscript preprocess.R

derived_data/reliability_RT.csv\
 derived_data/reliability_bus.csv\
 derived_data/reliability_bus_full.csv\
 derived_data/stop_ridership_mun.csv\
 derived_data/stop_ridership.csv: ridership_reliability_preprocess.R\
 source_data/Reliability.csv\
 source_data/Ridership.csv\
 source_data/Bus_Stops.csv
	Rscript ridership_reliability_preprocess.R

figures/population_stops.png\
 figures/boston_income_stops.png\
 figures/boston_population_stops.png\
 figures/boston_map_income.png\
 figures/boston_map_pop.png\
 figures/boston_map_numstops.png\
 figures/income_stops_noBoston.png\
 figures/eqv_stops_noBoston.png\
 figures/population_stops_noBoston.png: initial_figures.R\
 derived_data/municipality_stops.csv\
 derived_data/boston_demo.csv\
 source_data/Boston_Neighborhoods.geojson\
 derived_data/municipality_stops_NoBoston.csv
	Rscript initial_figures.R

figures/bus_onpeak.png\
 figures/bus_offpeak.png\
 figures/rt_onpeak.png\
 figures/rt_offpeak.png\
 figures/rtg_offpeak.png\
 figures/rtg_onpeak.png: reliability_figures.R\
 derived_data/reliability_bus.csv\
 derived_data/reliability_RT.csv
	Rscript reliability_figures.R

derived_data/peaktest.csv\
 derived_data/rpeaktest.csv\
 derived_data/roffpeaktest.csv\
 figures/relvrid.png\
 derived_data/offpeaktest.csv: reliability_tests.R\
 derived_data/reliability_bus_full.csv\
 derived_data/reliability_RT.csv
	Rscript reliability_tests.R

model_data/gbm_results.csv\
 model_data/stop_classification.csv\
 figures/roc_plot.png\
 figures/gbm_inf.png: stop_classification.R\
 derived_data/stop_ridership.csv
	Rscript stop_classification.R

# Build the final report for the project.
writeup.pdf: figures/population_stops.png\
 figures/boston_income_stops.png\
 figures/boston_population_stops.png\
 figures/boston_map_income.png\
 figures/boston_map_pop.png\
 figures/boston_map_numstops.png\
 figures/income_stops_noBoston.png\
 figures/eqv_stops_noBoston.png\
 figures/population_stops_noBoston.png\
 figures/bus_onpeak.png\
 figures/bus_offpeak.png\
 figures/rt_onpeak.png\
 figures/rt_offpeak.png\
 figures/rtg_offpeak.png\
 figures/rtg_onpeak.png\
 figures/roc_plot.png\
 figures/gbm_inf.png\
 derived_data/offpeaktest.csv\
 derived_data/peaktest.csv\
 derived_data/rpeaktest.csv\
 figures/relvrid.png\
 derived_data/roffpeaktest.csv
	Rscript -e "rmarkdown::render('writeup.Rmd')"
