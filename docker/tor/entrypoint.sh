#!/bin/sh
set -e

# Always copy the template torrc so updates are reflected on container restart
cp /tmp/torrc /etc/tor/torrc

# Change local user id and group
usermod -u "${LOCAL_USER_ID:?}" alice
groupmod -g "${LOCAL_GROUP_ID:?}" alice

# Create hidden service directory with correct permissions
mkdir -p "${TOR_DATA}/hidden_service"
chmod 700 "${TOR_DATA}/hidden_service"

# Set correct owners on volumes
chown -R tor:alice "${TOR_DATA}"
chown -R :alice /etc/tor
chown -R alice:alice /home/alice

exec sudo -u tor /usr/bin/tor