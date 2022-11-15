FROM rocker/verse 
RUN R -e "install.packages(\"matlab\")"
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y python3-pip sqlite3
RUN apt-get -y update && apt-get install -y  libudunits2-dev libgdal-dev libgeos-dev libproj-dev
RUN pip3 install beautifulsoup4 theano tensorflow keras sklearn pandas numpy pandasql 
RUN R -e "install.packages(\"reticulate\")";
RUN R -e "install.packages('caret');"
RUN R -e "install.packages('e1071');"
RUN R -e "install.packages('leaps');"
RUN R -e "install.packages('plotly');"
RUN R -e "install.packages('xlsx');"
RUN R -e "install.packages('sf');"
RUN R -e "install.packages('geojsonsf');"
RUN R -e "install.packages('spData');"
RUN R -e "install.packages('markdown');"
RUN R -e "install.packages('scales');"
RUN R -e "install.packages('chron');"
RUN Rscript --no-restore --no-save -e "update.packages(ask = FALSE);"

