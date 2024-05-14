FROM --platform=linux/amd64 php:7.4-apache

ENV WIKI_VERSION_MAJOR_MINOR=1.41
ENV WIKI_VERSION_BUGFIX=1
ENV WIKI_VERSION=$WIKI_VERSION_MAJOR_MINOR.$WIKI_VERSION_BUGFIX
ENV APCU_VERSION=5.1.18

RUN apt-get update && apt-get install -y --no-install-recommends \
        zlib1g-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libmagickwand-dev \
        libicu-dev \
        libldap2-dev \
        libldap-2.4-2 \
        libldap-common \
        netcat \
        git \
        imagemagick \
        unzip \
        vim.tiny \
        libonig-dev \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/* \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && docker-php-source extract

RUN pecl install apcu-${APCU_VERSION}

# RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j "$(nproc)" \
    gd \
    xml \
    mbstring \
    json \
    intl \
    mysqli \
    ;

WORKDIR /var/www/html

RUN curl -L https://releases.wikimedia.org/mediawiki/$WIKI_VERSION_MAJOR_MINOR/mediawiki-$WIKI_VERSION.tar.gz | tar xz --strip=1

EXPOSE 80