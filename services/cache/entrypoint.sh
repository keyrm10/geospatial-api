#!/usr/bin/env bash

set -e

envsubst '${UPSTREAM_URL}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
nginx -t
exec nginx -g 'daemon off;'
