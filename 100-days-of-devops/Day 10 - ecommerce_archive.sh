#!/bin/bash
set -e

# Define variables
SOURCE_DIR="/var/www/html/ecommerce"
ARCHIVE_NAME="xfusioncorp_ecommerce.zip"
LOCAL_ARCHIVE_PATH="/archives/$ARCHIVE_NAME"
STORAGE_USER="natasha"
STORAGE_HOST="ststor01"
REMOTE_ARCHIVE_DIR="/archives/"

echo "Start Backup..."


# Create the zip archive locally on App Server 3
echo "Create zip archive $ARCHIVE_NAME from $SOURCE_DIR into $LOCAL_ARCHIVE_PATH"
zip -r "$LOCAL_ARCHIVE_PATH" "$SOURCE_DIR"

# Copy the created archive to Nautilus Storage Server without asking for password
echo "Create archive to Nautilus Storage Server with $STORAGE_USER"
scp "$LOCAL_ARCHIVE_PATH" "${STORAGE_USER}@${STORAGE_HOST}:${REMOTE_ARCHIVE_DIR}"

echo "Check results"

# Execute the remote command and capture output
OUTPUT=$(ssh ${STORAGE_USER}@${STORAGE_HOST} "ls -la ${REMOTE_ARCHIVE_DIR}=" 2>&1)
STATUS=$?

# Display custom echo messages based on the result
if [ $STATUS -eq 0 ]; then
    echo "SUCCESS: Remote command executed successfully."
    echo "Directory contents:"
    echo "$OUTPUT"
else
    echo "ERROR: Failed to list ${REMOTE_ARCHIVE_DIR} on remote host (Exit code: $STATUS)."
    echo "Error details:"
    echo "$OUTPUT"
fi
echo "end of script"