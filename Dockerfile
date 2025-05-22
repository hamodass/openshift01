# Stage 1: Build the Flutter Web app
FROM debian:bullseye-slim AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl unzip xz-utils zip libglu1-mesa openjdk-11-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV FLUTTER_HOME=/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

# Clone Flutter SDK and enable web
RUN git clone https://github.com/flutter/flutter.git $FLUTTER_HOME \
    && flutter doctor \
    && flutter config --enable-web \
    && flutter upgrade

# Pre-download dependencies
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

# Copy the entire app and build
COPY . .
RUN flutter build web --release

# Stage 2: Serve the app using NGINX
FROM nginx:alpine

# Remove default site
RUN rm -rf /usr/share/nginx/html/*

# Copy build output from previous stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Optional: Custom NGINX config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
