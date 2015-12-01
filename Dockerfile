# Baseimage is a minimal Ubuntu 14.04 base image configured for correct use within Docker containers
# see https://github.com/phusion/baseimage-docker
# locked down to a specific version to make builds reproducible
FROM phusion/baseimage:0.9.17

MAINTAINER Damien Roch, damien.roch@gmail.com

# Use baseimage-docker's init system which will start NGinx, PHPFPM
CMD ["/sbin/my_init"]

###
# BASICS
###

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

# install base softwares
RUN apt-get update && \
    apt-get install -y vim curl wget build-essential python-software-properties

# Configure repositories
RUN add-apt-repository -y ppa:ondrej/php5-5.6 && \
    add-apt-repository -y ppa:nginx/stable && \
    apt-get -qy update

###
#  NGINX
###

# install NGINX from official PPA
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx

# configure NGINX
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && \
  	chown -R www-data:www-data /var/lib/nginx
RUN mkdir -p /var/www && \
  	chown -R www-data:www-data /var/www
ADD src/nginx/default_site   /etc/nginx/sites-available/default

# set runit NGINX
ADD src/nginx/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

###
#  PHP5 FPM
###

# install PHP-FPM
RUN apt-get install -y php5-fpm php5-cli php5-mysqlnd php5-sqlite php5-gd \
    php5-imagick php5-mcrypt php5-curl php5-intl

# configure PHP-FPM
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini

# set runit PHPFPM
ADD src/phpfpm/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x /etc/service/phpfpm/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80
EXPOSE 443
