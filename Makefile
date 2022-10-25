.PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data

.created-dirs:
	mkdir -p figures
	mkdir -p derived_data

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

# Build the final report for the project.
writeup.pdf: figures/bpi_intensity_by_group.png figures/demo-projection.png figures/outcomes_by_demographic_clustering.png
	pdflatex writeup.tex
