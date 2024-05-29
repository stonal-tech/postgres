# Use the PostGIS image as the base
FROM postgis/postgis:13-3.4

# https://github.com/pgvector/pgvector/tags
ARG PGVECTOR_VERSION=v0.5.1

# Install necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       wget \
       git \
    # Extract the Postgres version and set PG_MAJOR
    && PG_MAJOR=$(psql -V | awk '{print $3}' | cut -d '.' -f 1) \
    && apt-get install -y --no-install-recommends \
       postgresql-server-dev-${PG_MAJOR} \
    # Clean up to reduce layer size
    && rm -rf /var/lib/apt/lists/* \
    && git clone --branch ${PGVECTOR_VERSION} https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    # Clean up unnecessary files
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-${PG_MAJOR} libpq-dev wget git \
    && rm -rf /tmp/pgvector