611 Final Project
=================

This is the git repository for my final project for BIOS 611. This project will look at data from the state of Massachusetts, the city of Boston, and the Massachusetts Bay Transit Authority from the years 2018-2022.

Two of the files used in this project were too large to be put in my git repository. Steps to incorporate these files:

Download the CSV found here: https://mbta-massdot.opendata.arcgis.com/datasets/MassDOT::mbta-rail-ridership-by-time-period-season-route-line-and-stop/explore

Place in the source_data folder and rename to Ridership.csv

Download the CSV found here: https://mbta-massdot.opendata.arcgis.com/datasets/MassDOT::mbta-bus-commuter-rail-rapid-transit-reliability/explore

Place in the source_data folder and rename to Reliability.csv

To build the docker container to run this repository, run:

```
docker build . -t mbta-project
```
To launch the docker container, run (replacing yourpassword with a password of your choosing):

```
docker run -d -e PASSWORD=yourpassword --rm -p 8787:8787 -v $(pwd):/home/rstudio/project -t mbta-project
```

Once you're in the docker container, run:

```
cd project
```

Then to create the skeleton report, invoke:

```
make writeup.pdf
```