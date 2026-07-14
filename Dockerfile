FROM nginx:alpine

# Serve the static page
COPY index.html /usr/share/nginx/html/index.html

# Cloud Run provides $PORT (default 8080). Template nginx to listen on it.
COPY nginx.conf.template /etc/nginx/templates/default.conf.template
ENV PORT=8080

CMD ["/bin/sh", "-c", "envsubst '$PORT' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
