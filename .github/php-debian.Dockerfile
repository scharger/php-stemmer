
ARG PHP_VERSION=7.4
ARG BASE_IMAGE=php:$PHP_VERSION

# image0
FROM ${BASE_IMAGE}
RUN apt-get update && apt-get install -y \
        autoconf \
        automake \
        gcc \
        libstemmer-dev \
        libtool \
        m4 \
        make \
        pkg-config
WORKDIR /build/php-stemmer
ADD . .
RUN phpize
RUN ./configure CFLAGS="-O3"
RUN make
RUN make install

# image1
FROM ${BASE_IMAGE}
RUN apt-get update && apt-get install -y \
        libstemmer-dev
COPY --from=0 /usr/local/lib/php/extensions /usr/local/lib/php/extensions
RUN docker-php-ext-enable stemmer
ENTRYPOINT ["docker-php-entrypoint"]
