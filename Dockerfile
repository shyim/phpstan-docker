FROM --platform=$BUILDPLATFORM composer as download

ARG PHPSTAN_VERSION 1.10.50
ENV COMPOSER_HOME /composer

RUN composer global require phpstan/phpstan $PHPSTAN_VERSION \
    && composer global config --no-plugins allow-plugins.phpstan/extension-installer true \
    && composer global require phpstan/extension-installer \
    && composer global require phpstan/phpstan-doctrine phpstan/phpstan-phpunit phpstan/phpstan-nette phpstan/phpstan-symfony phpstan/phpstan-mockery phpstan/phpstan-webmozart-assert \
    && composer global show "*phpstan*" \
    && rm -rf /composer/cache

RUN echo 'memory_limit = -1' > /php.ini

FROM scratch

LABEL org.opencontainers.image.authors="shyim" \
      org.opencontainers.image.url="https://github.com/phpstan/phpstan" \
      org.opencontainers.image.documentation="https://phpstan.org" \
      org.opencontainers.image.source="https://github.com/shyim/phpstan-docker" \
      org.opencontainers.image.vendor="shyim" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.title="PHPStan"

COPY rootfs/ /
COPY --from=download /composer /composer
COPY --from=download /php.ini /etc/php/8.2/cli/conf.d/99-memory-limit.ini

ENTRYPOINT ["/usr/bin/php", "/composer/vendor/bin/phpstan"]