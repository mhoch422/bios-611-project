FROM rocker/verse 
RUN R -e "install.packages(\"matlab\")"
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y python3-pip sqlite3
RUN pip3 install beautifulsoup4 theano tensorflow keras sklearn pandas numpy pandasql 
RUN R -e "install.packages(\"reticulate\")";
RUN R -e "install.packages('caret');"
RUN R -e "install.packages('e1071');"
RUN R -e "install.packages('leaps');"
RUN R -e "install.packages('plotly');"
RUN R -e "install.packages('xlsx');"
