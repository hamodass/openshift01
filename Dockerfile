# Stage 1: Build Flutter Web App
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
COPY pubspec.* ./
RUN flutter pub get
COPY . .
RUN flutter build web --release

# Stage 2: Use unprivileged NGINX for OpenShift
FROM nginxinc/nginx-unprivileged:stable-alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

