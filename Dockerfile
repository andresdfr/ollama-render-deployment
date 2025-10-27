# Optimized Dockerfile for Render free tier (CPU-only)
FROM ollama/ollama:latest

# Install curl for health checks (si la imagen ya trae curl, esto no hace daño)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Environment variables (patrones recomendados)
# Nota: no incluyas el puerto en OLLAMA_HOST; el puerto por defecto ya es 11434
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_ORIGINS=*
ENV OLLAMA_MODELS=/app/models
ENV OLLAMA_NUM_PARALLEL=1
ENV OLLAMA_MAX_LOADED_MODELS=1
ENV OLLAMA_FLASH_ATTENTION=0

# App workdir y script de arranque
WORKDIR /app
# Si tu script se llama start_optimized.sh en el repo, lo copiamos como start.sh
COPY start_optimized.sh /app/start.sh
RUN chmod +x /app/start.sh

# Puerto de la API de Ollama
EXPOSE 11434

# Healthcheck contra el endpoint de tags de Ollama
HEALTHCHECK --interval=60s --timeout=30s --start-period=300s --retries=3 \
  CMD curl -f http://localhost:11434/api/tags || exit 1

# OVERRIDE del ENTRYPOINT/CMD de la imagen oficial:
# - ENTRYPOINT usa sh -c para ejecutar comandos shell
# - CMD ejecuta nuestro script (que debe arrancar 'ollama serve' y hacer el pull del modelo)
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/app/start.sh"]
``
