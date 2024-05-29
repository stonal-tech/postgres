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
       postgresql-server-dev-13 \
    # Clean up to reduce layer size
    && rm -rf /var/lib/apt/lists/* \
    && git clone --branch ${PGVECTOR_VERSION} https://github.com/pgvector/pgvector.git /tmp/pgvector \
    && cd /tmp/pgvector \
    && make \
    && make install \
    # Clean up unnecessary files
    && cd - \
    && apt-get purge -y --auto-remove build-essential postgresql-server-dev-13 libpq-dev wget git \
    && rm -rf /tmp/pgvector

