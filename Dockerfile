# Stage 1: Build the Flutter Web app
FROM debian:bullseye-slim AS build

# Install required packages
RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip libglu1-mesa openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV FLUTTER_HOME=/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
    && flutter doctor \
    && flutter config --enable-web \
    && flutter upgrade

# Set working directory
WORKDIR /app

# Copy pubspec files and get dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy app source code and build
COPY . .
RUN flutter build web --release

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Clear default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy Flutter web build
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
