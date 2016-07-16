# Mason PHP Docker Image

Lightweight Docker image for PHP and Nginx based on [Alpine](http://alpinelinux.org/). Total image size `~100mb` uncompressed and just `34mb` compressed!

> This image was primarily designed for the [Mason CLI](https://github.com/codemasonhq/mason-cli) and easy deployment to [Codemason](http://mason.ci). It is designed to be built upon and extended. It works great in development and production.

When in development your source will be mounted as a volume. Then, when you're ready to build your image, your app source will be baked into the image so it's completely portable. 

Nginx will serve files from `/app/public` and expose ports `80` and `443` inside the container.

## Quick Start
This image is available on [Docker Hub](https://hub.docker.com/r/codemasonhq/php) as an automated build. Simply run the following command to get it on your machine. 
```
docker pull codemasonhq/php
```

Then from your project root, spin it up with a `docker run` command
```
docker run -p 80:80 -v $(pwd):/app codemasonhq/php
```

> Remember: Nginx will serve files from `/app/public`.

## Usage 
This image has been designed to fit nicely into a larger ecosystem of Docker images and toolkits provided by Codemason. 

Using the [Mason CLI](http://mason.ci/docs/mason-cli) will make getting the full value out of this image and the broader ecosystem an absolute breeze. Simply run the following command in your project root.
```
$ mason craft --with="php"
```
  - [Tutorial: Mason CLI for Laravel](#)


This will create a `Dockerfile` in your project using `codemasonhq/php` as the base image.
```
FROM codemasonhq/php

MAINTAINER Your Name <email@example.com>

###########################################################################
# Application Dockerfile
###########################################################################
#
# This is your application's Dockerfile. The image assembled from
# this file runs your application. You can modify this file to
# create an image tailored to the needs of your application. 
#
```

It will also create a `docker-compose.yml` for your application.
```
###########################################################################
# Docker Compose File
###########################################################################
#
# Your Docker Compose file spins up your application's environment.
# It defines all of the services, network links and volumes to
# be used by your application. Modify this file as required.
#
version: '2'
services:
  app:
    build: . 
    volumes:
      - ./:/app
    ports:
      - "80:80"
      - "443:443"
```

With one command, you've just Dockerized an application! This also works for existing projects too.

Now you've got your project setup, you can spin it up with one easy command
```
docker-compose up
```

You'll be able to access your application at `http://<docker-ip>`, where `<docker-ip>` is either the value of running `boot2docker ip` if you are on Mac or Windows, or `localhost` if you are running Docker natively.

## Building
When you've modified your `Dockerfile` rebuild it by running 
```
docker-compose build 
```

## Deploying
Docker is incredible in the development environment but going from development to production in a respectable way is still a bit sketchy. 

This is where Codemason really stands out. We've deliberately built our ecosystem in an opinionated way so deployment is unbelievably simple.

First, initialise a local git repository and commit your files to it
```
$ cd pebble
$ git init
Initialized empty Git repository in .git/
$ git add .
$ git commit -m "initial commit"
[master (root-commit) f864362] initial commit
 77 files changed, 5763 insertions(+)
 ...
```

Then, `create` a Codemason application.
```
$ mason create

   Creating application on Codemason...

⁣     Application name (spoon-guide-1451)
⁣     Application path (/Users/ben/pebble)
⁣               Domain (spoon-guide-1451.mason.ci)

   ✔ Created application
   ✔ Created remote repository
   ✔ Added git remote codemason
```

Now it's time to deploy 🚀
```
$ mason deploy

   Deploying application to Codemason...

      Uploading [====================] 100% 0.0s
       Building [====================] 100% 0.0s, ✔ passed
      Launching [====================] 100% 0.0s

     *´¨)
    ¸.•´ ¸.•*´¨) ¸.•*¨)
   (¸.•´ (¸.•` ¤ Application deployed and running at hello-world-1234.mason.ci

```


