# Project Overview

For this project you will be creating a fresh repository - the link is in Pilot under Content - Projects - Project 5. This is the repo you will be using for this project.

You will notice that each part has "Milestone" labels and dates. This project is not due until 4/22. Completion of each milestone by the date specified for the milestone will get you 10% of extra credit per milestone date met. To qualify, you must submit your project to the Dropbox for Project 5 in Pilot.

# Running Local Project

## Installation
1. The simplest way to install docker on windows is to first install [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install).
2. After this, download [Docker Desktop](https://docs.docker.com/desktop/windows/install/), which during install, should auto-detect to WSL2.
3. Next, prepare some html files for your website and perform either one of these two options to 

## Buildling container
1. The more customizable option would be to create a Dockerfile with the following properties
```
    FROM httpd:latest
    COPY ./public-html/ /usr/local/apache2/htdocs/
    EXPOSE 80
```
2. Note that `./public-html/` needs to be a folder that is a directory above the one containing the website file/s. 
3. In the terminal, while in the `./public-html/` directory, run the command `docker build -t apache2 .` to build the apache/httpd container. 
4. If a more direct building/running method is necessary, type `docker run -dit --name apache2 -p 8080:80 -v "$PWD":/usr/local/apache2/htdocs/ httpd:latest` into the terminal instead. 

## Running container
1.  To run the container after making the Dockerfile, type `docker run -p 80:80 apache2` into the terminal. 

## Viewing project
1. Assuming all of the above was done locally, open up any browser and type `localhost:80` into the address bar.
2. The site may not be much, but it's honest work.
