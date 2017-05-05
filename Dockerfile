FROM ubuntu:16.04

MAINTAINER Jose Fonseca <jose@ditecnologia.com>

RUN locale-gen en_US.UTF-8

ENV LANG en_us.UTF-8
ENV LANGUAGE es_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
    && apt-get install -y nginx curl zip unzip git software-properties-common supervisor sqlite3 \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y php7.0-fpm php7.0-cli php7.0-mcrypt php7.0-gd php7.0-mysql \
       php7.0-imap php-memcached php7.0-mbstring php7.0-xml php7.0-curl \
       php7.0-sqlite3 php7.0-zip \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && apt-get remove -y --purge software-properties-common \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY docker/app/default /etc/nginx/sites-available/default

COPY docker/app/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

COPY docker/app/www.conf /etc/php/7.0/fpm/pool.d/www.conf

COPY . /var/www/html/

EXPOSE 80

COPY docker/app/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /var/www/html/

RUN cp .env.example .env

CMD ["/usr/bin/supervisord"]