FROM composer:1 as vendor
COPY /app/composer.json composer.json
COPY /app/composer.lock composer.lock
RUN composer install --ignore-platform-reqs --no-interaction --prefer-dist

FROM craftcms/nginx:7.4

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