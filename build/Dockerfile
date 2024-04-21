FROM valkey/valkey:7.2
# Get buildx data
ARG TARGETOS 
ARG TARGETARCH
# Install tiny
ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini-${TARGETARCH} /tini
RUN chmod +x /tini
# Install s3fs
RUN apt-get update && apt-get install -y s3fs && \
    rm -rf /var/lib/apt/lists/*
# Set up entrypoint script to handle environment variables and mount s3fs
COPY ../docker-*.sh /
RUN chmod +x /docker-*.sh
# Define healthcheck
HEALTHCHECK --interval=5s --timeout=2s --start-period=10s --retries=3 CMD [ "/docker-healthcheck.sh" ]
# Define the entry point to execute the performance testing script
ENTRYPOINT ["/tini", "--", "/docker-entrypoint.sh"]