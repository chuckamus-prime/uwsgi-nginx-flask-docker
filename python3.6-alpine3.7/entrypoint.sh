#! /usr/bin/env sh
set -e
# Get the maximum upload file size for Nginx, default to 0: unlimited
USE_NGINX_MAX_UPLOAD=${NGINX_MAX_UPLOAD:-0}
# Generate Nginx config for maximum upload file size
echo "client_max_body_size $USE_NGINX_MAX_UPLOAD;" > /etc/nginx/conf.d/upload.conf

# Get the number of workers for Nginx, default to 1
USE_NGINX_WORKER_PROCESSES=${NGINX_WORKER_PROCESSES:-1}
# Modify the number of worker processes in Nginx config
sed -i "/worker_processes\s/c\worker_processes ${USE_NGINX_WORKER_PROCESSES};" /etc/nginx/nginx.conf

# Set the max number of connections per worker for Nginx, if requested
# Cannot exceed worker_rlimit_nofile, see NGINX_WORKER_OPEN_FILES below
if [[ -v NGINX_WORKER_CONNECTIONS ]] ; then
    sed -i "/worker_connections\s/c\    worker_connections ${NGINX_WORKER_CONNECTIONS};" /etc/nginx/nginx.conf
fi

# Set the max number of open file descriptors for Nginx workers, if requested
if [[ -v NGINX_WORKER_OPEN_FILES ]] ; then
    echo "worker_rlimit_nofile ${NGINX_WORKER_OPEN_FILES};" >> /etc/nginx/nginx.conf
fi

# Get the listen port for Nginx, default to 443
USE_LISTEN_PORT=${LISTEN_PORT:-443}

# Explicitly add installed Python packages and uWSGI Python packages to PYTHONPATH
# Otherwise uWSGI can't import Flask
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.6/site-packages:/usr/lib/python3.6/site-packages

# Generate Nginx config first part using the environment variables
echo "server {
    listen ${USE_LISTEN_PORT} ssl;
    ssl_certificate /etc/pki/nginx/chain.pem;
    ssl_certificate_key /etc/pki/nginx/private/key.pem;
    ssl_protocols TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5:!RSA;

    location / {
        try_files \$uri @app;
    }

    location @app {
        include uwsgi_params;
        uwsgi_pass unix:///tmp/uwsgi.sock;
    }
}" >> /etc/nginx/conf.d/nginx.conf

exec "$@"
