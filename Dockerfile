FROM wordpress

# XDebug extension
RUN pecl uninstall xdebug \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Enable XDebug
# remote host if your local machine IP, use host.docker.internal for Docker Desktop
RUN echo '[PHP] \n\
memory_limit=512M \n\
[XDebug] \n\
xdebug.mode=develop,debug \n\
xdebug.start_with_request=yes \n\
xdebug.discover_client_host=true \n\
xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini