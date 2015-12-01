# Nginx and PHP-FPM Stack

Based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) base Ubuntu image

## Run the docker container

    docker run -v path/to/local/web:/var/www:rw -p 80:80 -d koryonik/nginx-php
