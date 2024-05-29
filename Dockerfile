# Use the PostGIS image as the base
FROM postgis/postgis:13-3.4

# https://github.com/pgvector/pgvector/tags
ARG PGVECTOR_VERSION=v0.7.0

# Install necessary packages
RUN apt-get update && \
    PG_MAJOR=$(psql -V | awk '{print $3}' | cut -d '.' -f 1) \
    apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       wget \
       git \
       postgresql-server-dev-${PG_MAJOR} \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --branch ${PGVECTOR_VERSION} https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-${PG_MAJOR} libpq-dev wget git \
    && rm -rf /tmp/pgvector
