# Stage 1: Build Flutter Web app
FROM debian:bullseye-slim AS build

RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip libglu1-mesa openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

ENV FLUTTER_HOME=/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
    && flutter doctor \
    && flutter config --enable-web \
    && flutter upgrade

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .
RUN flutter build web --release

# Stage 2: Use an unprivileged NGINX base image
FROM nginxinc/nginx-unprivileged:stable-alpine

# Remove default files
RUN rm -rf /usr/share/nginx/html/*

# Copy built app
COPY --from=build /app/build/web /usr/share/nginx/html

# Custom nginx config (optional)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Use the unprivileged port
EXPOSE 8080

# Start NGINX as non-root
CMD ["nginx", "-g", "daemon off;"]
