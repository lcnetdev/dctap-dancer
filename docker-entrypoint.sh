#!/bin/sh
set -e

# Ensure /app/data is writable by the nodejs user (uid 1001)
# This handles the case where a volume is mounted with root ownership
chown -R nodejs:nodejs /app/data 2>/dev/null || true

# Drop privileges and run the command as the nodejs user
exec su-exec nodejs "$@"
