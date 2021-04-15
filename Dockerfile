FROM php:7.4.16-fpm

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update

RUN apt-get install git nodejs npm libcurl4-gnutls-dev libicu-dev libmcrypt-dev libvpx-dev  \
    libjpeg-dev libpng-dev libxpm-dev zlib1g-dev libfreetype6-dev libxml2-dev libexpat1-dev \
    libbz2-dev libgmp3-dev libldap2-dev unixodbc-dev libpq-dev libsqlite3-dev libaspell-dev \
    libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev libsnmp-dev      \
    libpcre3-dev libtidy-dev libzip-dev libonig-dev rsync -yqq

RUN npm install pm2 -g

RUN pecl install swoole redis
RUN docker-php-ext-enable swoole redis

RUN docker-php-ext-install mbstring pdo pdo_mysql mysqli curl json intl xml zip bz2 opcache bcmath gd fileinfo pcntl ldap

RUN docker-php-ext-configure gd \
    --with-webp \
    --with-jpeg \
    --with-freetype

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir="/usr/bin" --filename=composer
RUN php -r "unlink('composer-setup.php');"

RUN chmod +x "/usr/bin/composer"
