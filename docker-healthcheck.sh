#!/bin/sh
# Set default values for s3 that can be unset
S3_MOUNTER=${S3_MOUNTER:-"s3fs"}
# Mount s3fs
if [ "${S3_MOUNTER}" = "s3fs" ]; then
    # Set default values for s3fs that can be unset
    S3FS_DIR=${S3FS_DIR:-"/data"}
    # Use ls to simulate a input/output action.
    ls ${S3FS_DIR} || exit 1
fi
# Return success errorlevel 0
exit 0