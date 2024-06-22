# see https://github.com/postgis/docker-postgis/blob/master/Dockerfile.template
FROM postgres:16.3

# https://github.com/postgis/postgis/tags
ENV POSTGIS_VERSION 3.4.2

# https://github.com/pgvector/pgvector/tags
ENV PGVECTOR_V_VERSION v0.7.2

# Remove the first v letter
RUN set -ex && \
    export PGVECTOR_VERSION=$(echo $PGVECTOR_V_VERSION | cut -c 2-) && \
    export POSTGIS_MAJOR=$(echo $POSTGIS_VERSION | cut -d. -f1) && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION* \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
           postgresql-$PG_MAJOR-pgvector=$PGVECTOR_VERSION* && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/10_postgis.sh
COPY ./update-postgis.sh /usr/local/bin
