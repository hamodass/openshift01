# Stage 1: Build the Flutter Web app
FROM dart:stable AS build

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /flutter \
    && flutter/bin/flutter --version

# Add Flutter to PATH
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter config --enable-web

# Pre-download dependencies
WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

# Copy source and build web app
COPY . .
RUN flutter build web --release

# Stage 2: Serve the app with NGINX
FROM nginx:alpine

# Remove default nginx site
RUN rm -rf /usr/share/nginx/html/*

# Copy build output to nginx directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy custom nginx config (optional, see below)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
