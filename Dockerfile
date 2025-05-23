# --- Stage 1: Build Flutter Web App ---
FROM debian:bullseye-slim AS build

RUN apt-get update && apt-get install -y \
  git curl unzip xz-utils zip libglu1-mesa openjdk-11-jdk \
  && rm -rf /var/lib/apt/lists/*

ENV FLUTTER_HOME=/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
  && flutter doctor \
  && flutter config --enable-web

WORKDIR /app

# Pre-cache dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy source and build
COPY . .
RUN flutter build web --release

# --- Stage 2: NGINX for Serving ---
FROM nginxinc/nginx-unprivileged:stable-alpine

# Remove default nginx config to avoid permission issue in OpenShift
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom config (make sure it sets port 8080!)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy web build output
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 8080

USER 1001  # required for OpenShift non-root policy

CMD ["nginx", "-g", "daemon off;"]
