FROM ubuntu:16.04

MAINTAINER Jeffrey Rios <yefriddavid@gmail.com>


RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

ENV LANG en_us.UTF-8
ENV LANGUAGE es_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
    && apt-get install -y nginx curl zip unzip git software-properties-common supervisor sqlite3 \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y \
    	php7.2-fpm \
    	php7.2-cli \
	php7.1-mcrypt \
	php7.2-gd \
	php7.2-mysql \
       	php7.2-imap \
	php-memcached \
	php7.2-mbstring \
	php7.2-xml \
	php7.2-curl \
       	php7.2-sqlite3 \ 
	php7.2-zip \
	php7.2-pdo-dblib \
    ## php-mongodb \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

#COPY default /etc/nginx/sites-available/default
#COPY php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf
#COPY www.conf /etc/php/7.2/fpm/pool.d/www.conf

EXPOSE 80

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
