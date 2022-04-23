# Project Overview

For this project you will be creating a fresh repository - the link is in Pilot under Content - Projects - Project 5. This is the repo you will be using for this project.

You will notice that each part has "Milestone" labels and dates. This project is not due until 4/22. Completion of each milestone by the date specified for the milestone will get you 10% of extra credit per milestone date met. To qualify, you must submit your project to the Dropbox for Project 5 in Pilot.

# Part 1 - Dockerize it

## Installation
1. The simplest way to install docker on windows is to first install [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install).
2. After this, download [Docker Desktop](https://docs.docker.com/desktop/windows/install/), which during install, should auto-detect to WSL2.
3. Next, prepare some html files for your website and perform either one of these two options to 

## Building container
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

# Part 2 - GitHub Actions and DockerHub

## Create DockerHub public repo
1. Log into [DockerHub](https://hub.docker.com/) with your credentials.
2. Click on `Repositories` >> `Create Repository`, then give your new repository a name/description and make sure its visibility is set to public.
3. Congratulations, it's a repo!

## How to authenticate with DockerHub via CLI
1. While you're still logged into DockerHub, go to your [security settings](https://hub.docker.com/settings/security) and click on `New Access Token`.
2. Give it a description, click on generate, and protect that token with your life. 
3. To log into DockerHub through the terminal, type `docker login -u <username>` and enter the token you made as the password.

## Configuring GitHub Secrets
1. The same username and token you used to login through the terminal are the ones needed for the GitHubs secrets.
2. In your repository, click on `Settings` >> `Secrets` >> `Actions` >> `New repository secret`.
3. First, enter `DOCKER_HUB_USERNAME` and the name of the secret and your DockerHub username as its value.
4. Next, create a new secret named `DOCKER_HUB_ACCESS_TOKEN`, with the value of the token from the previous steps.

## Behavior of GitHub workflow
1. The workflow defined in `apache.yml` pushes the pushed version of the apache2 image to its DockerHub repo when the GitHub repo's main branch is pushed. 
2. To fix the template in order to make the workflow work as desired, I had to change the following`
    * `release: types: [published]` >> `push: branches: [master]`
    * all `uses: ` to their proper version number (v1, v3, v2)
    * `secrets.DOCKER_USERNAME` >> `secrets.DOCKER_HUB_USERNAME`
    * `secrets.DOCKER_PASSWORD` >> `secrets.DOCKER_HUB_ACCESS_TOKEN`
    * `my-docker-hub-namespace/my-docker-hub-repository` >> `gerselle/lab6`

# Part 3 - Deployment

## Container restart script
1. When the webhook receives a request from a client application, it uses the container restart script to pull the latest Docker image, stop the container, delete it, and replace it with the newer version. 

## Webhook task definition file
1. Open

## Setting up a webhook on the server
### Creating listener
1. First, use `sudo apt install webhook` to download the webhooks tool, which is the main component of making this stuff work
2. Next, place the files in the `hooks` directory anywhere on the server where the webhook will be running on
3. Then use the command `/path/to/webhook -hooks hooks.json -verbose` to start the webhook, you need to leave this running
4. When a outside client sends a request to the server, it will automatically attempt to start the script that's in `hooks`

### Setting up notifier for GitHub or DockerHub
1. Admittedly, I couldn't get the webhook to work properly, the webhook tool would keep throwing a fork/exec error every time my client sent a request
2. But if it was working, this is how I'm pretty sure it would work on both platforms
    * Github - Add an additional secret, DEPLOY_WEBHOOK_URL, and add the following to the current apache.yml file or another workflow like it:
        ``` 
            redeploy:
                name: Redeploy - Webhook call
                runs-on: ubuntu-18.04
                needs: [docker]
                steps:
                - name: Deploy docker container webhook
                    uses: joelwmale/webhook-action@master
                    env:
                    WEBHOOK_URL: ${{ secrets.DEPLOY_WEBHOOK_URL  }}
                    data: "{ 'myField': 'myFieldValue'}" 
        ```
    * DockerHub - 
        * First go to your repository and click on `Webhooks`
        * Create a webhook by thinking of a name for it and putting in its url
        * ???
        * PROFIT!!!
