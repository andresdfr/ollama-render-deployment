# Dockerfile
FROM ollama/ollama:latest

# Set environment variables
ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_ORIGINS=*
ENV OLLAMA_MODELS=/app/models

# Create models directory
RUN mkdir -p /app/models

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose port
EXPOSE 11434

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:11434/api/tags || exit 1

# Start the service
CMD ["/app/start.sh"]