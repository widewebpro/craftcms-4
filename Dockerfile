FROM composer:1 as vendor
COPY /app/composer.json composer.json
COPY /app/composer.lock composer.lock
COPY /app/plugins plugins
RUN composer clearcache
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/nginx:7.4

# setup general options for environment variables
ARG PHP_MEMORY_LIMIT_ARG="1024M"
ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT_ARG}
ARG PHP_MAX_EXECUTION_TIME_ARG="120"
ENV PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME_ARG}
ARG PHP_UPLOAD_MAX_FILESIZE_ARG="998M"
ENV PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE_ARG}
ARG PHP_MAX_INPUT_VARS_ARG="1000"
ENV PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS_ARG}
ARG PHP_POST_MAX_SIZE_ARG="999M"
ENV PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE_ARG}

# setup opcache for environment variables
ARG PHP_OPCACHE_ENABLE_ARG="1"
ARG PHP_OPCACHE_REVALIDATE_FREQ_ARG="0"
ARG PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG="0"
ARG PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG="10000"
ARG PHP_OPCACHE_MEMORY_CONSUMPTION_ARG="128"
ARG PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG="10"
ARG PHP_OPCACHE_INTERNED_STRINGS_BUFFER_ARG="16"
ARG PHP_OPCACHE_FAST_SHUTDOWN_ARG="1"
ENV PHP_OPCACHE_ENABLE=$PHP_OPCACHE_ENABLE_ARG
ENV PHP_OPCACHE_REVALIDATE_FREQ=$PHP_OPCACHE_REVALIDATE_FREQ_ARG
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=$PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=$PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=$PHP_OPCACHE_MEMORY_CONSUMPTION_ARG
ENV PHP_OPCACHE_MAX_WASTED_PERCENTAGE=$PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG
ENV PHP_OPCACHE_INTERNED_STRINGS_BUFFER=$PHP_OPCACHE_INTERNED_STRINGS_BUFFER_ARG
ENV PHP_OPCACHE_FAST_SHUTDOWN=$PHP_OPCACHE_FAST_SHUTDOWN_ARG

USER root

COPY .devops/nginx.conf /etc/nginx/nginx.conf
COPY .devops/craftcms/general.conf /etc/nginx/craftcms/
COPY .devops/craftcms/php_fastcgi.conf /etc/nginx/craftcms/
COPY .devops/craftcms/security.conf /etc/nginx/craftcms/
COPY .devops/default.conf /etc/nginx/conf.d/default.conf

RUN chown www-data /run/nginx.pid
RUN chown www-data /run/supervisord.pid
RUN chown -R www-data:www-data /var/lib/nginx/logs/
# switch to the root user to install mysql tools
USER www-data
# the user is `www-data`, so we copy the files using the user and group
COPY --chown=www-data:www-data --from=vendor /app/vendor/ /app/vendor/
RUN mkdir storage
COPY --chown=www-data:www-data app/. .