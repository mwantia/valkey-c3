FROM valkey/valkey:7.2
# Install s3fs
RUN apt-get update && apt-get install -y s3fs && \
    rm -rf /var/lib/apt/lists/*
# Set up entrypoint script to handle environment variables and mount s3fs
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
# Define the entry point to execute the performance testing script
ENTRYPOINT ["/docker-entrypoint.sh"]
# Define the default arguments used
CMD ["--dir", "/data", "--save", "60 1", "--loglevel", "warning"]