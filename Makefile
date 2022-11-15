.PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data
	rm -rf writeup.pdf

.created-dirs:
	mkdir -p figures
	mkdir -p derived_data

derived_data/stop_info.csv\
 derived_data/municipality_stops.csv\
 derived_data/fin_info.csv\
 derived_data/boston_stop_info.csv\
 derived_data/boston_demo.csv\
 derived_data/reliability_RT.csv\
 derived_data/reliability_bus.csv\
 derived_data/stop_ridership.csv\
 derived_data/municipality_stops_NoBoston.csv: preprocess.R\
 source_data/Boston_Neighborhoods.geojson\
 source_data/Boston_Neighborhoods_tables.xlsm\
 source_data/Bus_Stops.csv\
 source_data/RT_stops.csv\
 source_data/population.csv\
 source_data/Reliability.csv\
 source_data/Ridership.csv
	Rscript preprocess.R

figures/population_stops.png\
 figures/bus_onpeak.png\
 figures/bus_offpeak.png\
 figures/rt_onpeak.png\
 figures/rt_offpeak.png\
 figures/rtg_offpeak.png\
 figures/rtg_onpeak.png\
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
 derived_data/reliability_RT.csv\
 derived_data/reliability_bus.csv\
 source_data/Boston_Neighborhoods.geojson\
 derived_data/municipality_stops_NoBoston.csv
	Rscript initial_figures.R

# Build the final report for the project.
writeup.pdf: figures/population_stops.png\
 figures/boston_income_stops.png\
 figures/boston_population_stops.png\
 figures/boston_map_income.png\
 figures/boston_map_pop.png\
 figures/boston_map_numstops.png\
 figures/income_stops_noBoston.png\
 figures/eqv_stops_noBoston.png\
 figures/population_stops_noBoston.png
	Rscript -e "rmarkdown::render('writeup.Rmd')"
