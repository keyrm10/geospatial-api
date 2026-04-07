ARG NGINX_VERSION=1.29.5
ARG ALPINE_VERSION=3.23

FROM nginxinc/nginx-unprivileged:${NGINX_VERSION}-alpine${ALPINE_VERSION}-slim

COPY nginx.conf /etc/nginx/nginx.conf.template
COPY --chmod=755 entrypoint.sh /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
