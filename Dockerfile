# Frontend build stage
FROM node:22-alpine AS frontend-builder


ARG VITE_BASE_PATH=./
ENV VITE_BASE_PATH=$VITE_BASE_PATH

WORKDIR /app/frontend

# Copy frontend package files
COPY frontend/package.json ./

# Install frontend dependencies
RUN npm install

# Copy frontend source
COPY frontend/ ./

# Build frontend
RUN npm run build

# Backend build stage
FROM node:22-alpine AS backend-builder

WORKDIR /app

# Copy backend package files
COPY backend/package.json ./

# Install all dependencies (including dev for building)
RUN npm install

# Copy backend source code
COPY backend/tsconfig.json ./
COPY backend/src ./src

# Build TypeScript
RUN npm run build

# Production stage
FROM node:22-alpine AS production

WORKDIR /app

# Create non-root user for security and install su-exec for entrypoint
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 && \
    apk add --no-cache su-exec

# Copy backend package files
COPY backend/package.json ./

# Install production dependencies only
RUN npm install --omit=dev && \
    npm cache clean --force

# Copy built backend files
COPY --from=backend-builder /app/dist ./dist

# Copy built frontend files
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

# Create data directory for SQLite databases
RUN mkdir -p /app/data && chown -R nodejs:nodejs /app/data

# Copy entrypoint script
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Expose port
EXPOSE 3000

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/health || exit 1

# Start via entrypoint (runs as root to fix permissions, then drops to nodejs)
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["node", "dist/index.js"]
