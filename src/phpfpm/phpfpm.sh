#!/usr/bin/env bash

#see l33t.peopleperhour.com/blog/2014/03/13/setting-environment-variables-in-php-fpm-when-using-docker-links/
CONF_FILE_LOCATION=”/etc/php5/fpm/pool.d/www.conf”

php5-fpm -c /etc/php5/fpm
