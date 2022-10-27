611 Final Project
=================

This is the git repository for my final project for BIOS 611. This project will look at data from the state of Massachusetts, the city of Boston, and the Massachusetts Bay Transit Authority from the years 2018-2022.

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