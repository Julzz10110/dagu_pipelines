# first stage: pull official image of DAGU
FROM ghcr.io/dagu-org/dagu:latest as dagu

# second stage: base Ubuntu image
FROM ubuntu:24.04

# copy DAGU from first stage
COPY --from=dagu /usr/local/bin/dagu /usr/local/bin/dagu

# install system deps
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# install Node.js 20.x (LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm@latest \
    && corepack enable

# check versions
RUN node -v && npm -v && dagu version

# set up the working directory
WORKDIR /app

# open a port for the DAGU web-interface
EXPOSE 8080

# DAGU data volume
VOLUME ["/var/lib/dagu"]

# launch DAGU server with web-interface
CMD ["dagu", "server", "--host", "0.0.0.0"]