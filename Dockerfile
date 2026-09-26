FROM php:7.3.33-apache-bullseye

ARG DEBIAN_SNAPSHOT=20260903T220410Z
ARG DEBIAN_SECURITY_SNAPSHOT=20260903T220410Z

RUN set -eux; \
    rm -f /etc/apt/sources.list.d/*; \
    printf '%s\n' \
        "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian/${DEBIAN_SNAPSHOT}/ bullseye main" \
        "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian/${DEBIAN_SNAPSHOT}/ bullseye-updates main" \
        "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian-security/${DEBIAN_SECURITY_SNAPSHOT}/ bullseye-security main" \
        > /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        default-mysql-client \
        libfreetype6-dev \
        libgmp-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libpq-dev \
        libzip-dev \
        unzip \
        zip \
        git \
        vim; \
    docker-php-ext-install \
        mysqli \
        pdo_mysql \
        mbstring \
        zip; \
    a2enmod rewrite; \
    rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.title="Lemon Internet PHP 7.3.33 Apache"
LABEL org.opencontainers.image.description="Legacy PHP 7.3.33 Apache image with reproducible Debian Bullseye snapshots"
LABEL org.opencontainers.image.version="7.3.33"
