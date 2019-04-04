# FROM php:7.2-apache
FROM php:7-apache

RUN apt-get update \
  && apt-get install -y \
  curl \
  build-essential \
  openssl libssl-dev \
  libcurl4-openssl-dev \
  libpq-dev \
  libxml2-dev \
  libldap2-dev \
  libgd-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  zlib1g-dev \
  zip \
  unzip \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) curl iconv tokenizer mbstring pdo pdo_pgsql xmlrpc \
  # && pear install Log-1.13.1 \
  && a2enmod rewrite \
  && a2enmod ssl \
  && a2dissite 000-default

# PEAR server が down しているため、直接インストール
RUN curl -LO https://github.com/pear/Log/releases/download/1.13.1/Log-1.13.1.tgz \
  && pear install Log-1.13.1.tgz

# Install Xdebug
RUN pecl install xdebug && \
  docker-php-ext-enable xdebug && \
  sed -i '1 a xdebug.idekey="ps_sample_php7"' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_autostart=true' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_mode=req' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_handler=dbgp' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_connect_back=1 ' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_port=9002' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  # sed -i '1 a xdebug.remote_host=127.0.0.1' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
  sed -i '1 a xdebug.remote_enable=1' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install timecop
RUN pecl install timecop-beta && \
  docker-php-ext-enable timecop

# Install ldap
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu && \
  docker-php-ext-install ldap

RUN mkdir -p /var/log/php

# CA 追加
COPY ./01_proxy/openssl/ca/sample-dev.cacrt.pem /usr/share/ca-certificates/sample-dev.cacrt.pem
RUN echo "sample-dev.cacrt.pem" >> /etc/ca-certificates.conf
RUN /usr/sbin/update-ca-certificates
