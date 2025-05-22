# Stage 1: Build Flutter Web App
FROM debian:bullseye-slim AS build

# Install build dependencies
RUN apt-get update && apt-get install -y \
  git curl unzip xz-utils zip libglu1-mesa openjdk-11-jdk \
  && rm -rf /var/lib/apt/lists/*

# Setup Flutter
ENV FLUTTER_HOME=/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
  && flutter doctor \
  && flutter config --enable-web \
  && flutter upgrade

# Prepare app
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .
RUN flutter build web --release

# Stage 2: Serve using non-root NGINX (safe for OpenShift)
FROM nginxinc/nginx-unprivileged:stable-alpine

# Copy web build to nginx html dir
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx config (must listen on port 8080)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080 (required by unprivileged nginx)
EXPOSE 8080

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
