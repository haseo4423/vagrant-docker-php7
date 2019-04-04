FROM php:7.2-apache

RUN apt-get update \
  && apt-get install -y \
  curl \
  build-essential \
  openssl libssl-dev \
  libcurl4-openssl-dev \
  libxml2-dev \
  libgd-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  zlib1g-dev \
  zip \
  unzip \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) curl iconv tokenizer mbstring xmlrpc

RUN mkdir -p /var/log/php

# CA 追加
COPY ./01_proxy/openssl/ca/sample-dev.cacrt.pem /usr/share/ca-certificates/sample-dev.cacrt.pem
RUN echo "sample-dev.cacrt.pem" >> /etc/ca-certificates.conf
RUN /usr/sbin/update-ca-certificates

WORKDIR /home/devTools
