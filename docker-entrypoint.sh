#!/bin/sh
# Set default values for s3 that can be unset
S3_URL=${S3_URL:-"http://127.0.0.1:9000"}
S3_MOUNTER=${S3_MOUNTER:-"s3fs"}
# Return error if one of the required environment variables for valkey are unset
if [ -z ${VALKEY_DBNAME+x} ]; then echo "VALKEY_DBNAME is unset but required"; exit 1; fi
# Return error if one of the required environment variables for s3 are unset
if [ -z ${S3_BUCKET_NAME+x} ]; then echo "S3_BUCKET_NAME is unset but required"; exit 1; fi
if [ -z ${S3_ACCESS_KEY+x} ];  then echo "S3_ACCESS_KEY is unset but required"; exit 1; fi
if [ -z ${S3_SECRET_KEY+x} ];  then echo "S3_SECRET_KEY is unset but required"; exit 1; fi
# Set default values for s3fs that can be unset
S3FS_OPTIONS=${S3FS_OPTIONS:-"-o use_path_request_style -o dbglevel=debug -o nonempty"}
S3FS_DIR=${S3FS_DIR:-"/data"}
if [ "${S3_MOUNTER}" = "s3fs" ]; then
    # Create directory for mounting S3 bucket
    mkdir -p ${S3FS_DIR}
    chmod 600 ${S3FS_DIR}
    #
    cat > /valkey.conf << EOF
dir ${S3FS_DIR}
dbfilename ${VALKEY_DBNAME}.vdb
save 60 100
loglevel warning
EOF
    # Store S3 access credentials to passwd file
    echo "${S3_ACCESS_KEY}:${S3_SECRET_KEY}" > ${HOME}/.passwd-s3fs
    chmod 600 ${HOME}/.passwd-s3fs
    # Mount our S3 bucket to S3_MOUNT_DIR
    s3fs ${S3_BUCKET_NAME} ${S3FS_DIR} -o passwd_file=${HOME}/.passwd-s3fs -o url=${S3_URL} ${S3FS_OPTIONS}
    # s3fs can claim to have a mount even though it didn't succeed. 
    # Doing an operation actually forces it to detect that and remove the mount.
    stat ${S3FS_DIR}
    # Ensure that fuse mounts exists and is active
    if (grep fuse.s3fs /proc/mounts | grep -q "${S3_MOUNT_DIR}"); then
        # Execute the command passed to the entrypoint
        exec "valkey-server" "/valkey.conf" "$@"
        exit 0
    fi
fi

echo "Invalid mounter value defined in SE_MOUNTER"
exit 1