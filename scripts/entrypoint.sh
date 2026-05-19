#!/bin/sh

ONION_FILE="/var/lib/tor/hidden_service/hostname"
if [ -d "/var/lib/tor" ]; then
    echo "Waiting for Tor hidden service hostname..."
    WAIT=0
    while [ ! -f "$ONION_FILE" ]; do
        sleep 1
        WAIT=$((WAIT + 1))
        if [ $WAIT -ge 30 ]; then
            echo "Warning: Tor onion hostname not found after 30s, continuing without it"
            break
        fi
    done
    if [ -f "$ONION_FILE" ]; then
        ONION=$(cat "$ONION_FILE" | tr -d '\n')
        export ONION_LOCATION="$ONION"
        echo ">>> DimBR Onion: http://${ONION}"
    fi
fi

# Apply migrations
python manage.py migrate

# Collect static files
if [ $SKIP_COLLECT_STATIC ]; then
    echo "Skipping collection of static files."
else
    python manage.py collectstatic --noinput
fi

# Install python development dependencies
if [ $DEVELOPMENT ]; then
    echo "Installing python development dependencies"
    pip install -r requirements_dev.txt
fi

# Print first start up message when pb2/grpc files if they do exist
if [ ! -f "/usr/src/robosats/api/lightning/lightning_pb2.py" ]; then
    echo "Looks like the first run of this container. pb2 and gRPC files were not detected on the attached volume, copying them into the attached volume /robosats/api/lightning ."
fi

# Copy and overwrite all existing pb2/grpc files always. Therefore, running
# /scripts/generate_grpc.sh only makes sense if done during Dockerfile build
cp -R /tmp/* /usr/src/robosats/api/lightning/

# Start server / gunicorn / daphne / command
exec "$@"