# syntax=docker/dockerfile:1.4

FROM php:8.2-apache AS app_php

ARG APP_ENV

WORKDIR /var/www/html

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y  \
    libmcrypt-dev \
    libpng-dev  \
    libfreetype6-dev \
    libyaml-dev \
    curl \
    unzip \
    libpq-dev \
    acl \
   && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
   && docker-php-ext-install pdo pdo_pgsql pgsql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite && a2enmod ssl

RUN pecl install yamL

RUN if [[ "$APP_ENV" = "dev" ]] ; then sed -i '/SSLCertificateFile.*snakeoil\.pem/c\SSLCertificateFile \/etc\/ssl\/certs\/mycert.crt' /etc/apache2/sites-available/default-ssl.conf && sed -i '/SSLCertificateKeyFile.*snakeoil\.key/cSSLCertificateKeyFile /etc/ssl/private/mycert.key\' /etc/apache2/sites-available/default-ssl.conf; fi

ENV NODE_VERSION=19.5.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN npm install -g npm@9.4.0

COPY --link server/docker-entrypoint.$APP_ENV.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]