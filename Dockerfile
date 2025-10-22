# Multi-stage build for the sticker picker web application
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY web/package.json web/yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy source code
COPY web/ ./

# Build the application
RUN yarn esinstall && yarn sass

# Production stage with nginx
FROM nginx:alpine

# Copy built application to nginx html directory
COPY --from=builder /app /usr/share/nginx/html

# Copy nginx configuration (optional - nginx default config should work)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
