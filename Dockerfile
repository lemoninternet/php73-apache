FROM php:7.3.33-apache-bullseye

ARG DEBIAN_SNAPSHOT=20260903T220410Z
ARG DEBIAN_SECURITY_SNAPSHOT=20260903T220410Z

ENV COMPOSER_ALLOW_SUPERUSER=1

# Debian Bullseye security repository is no longer reliable after EOL.
# Use immutable Debian snapshots instead.
RUN set -eux; \
    rm -f /etc/apt/sources.list.d/*; \
    rm -rf /var/lib/apt/lists/*; \
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

# Composer version compatible with PHP 7.3
COPY --from=composer:2.2 /usr/bin/composer /usr/local/bin/composer

LABEL \
    org.opencontainers.image.title="PHP 7.3.33 Apache" \
    org.opencontainers.image.description="PHP 7.3.33 Apache Bullseye base image" \
    org.opencontainers.image.source="https://github.com/lemoninternet/php73-apache"