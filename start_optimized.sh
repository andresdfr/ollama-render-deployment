#!/usr/bin/env bash
set -euo pipefail

MODEL="${MODEL:-llama3:8b}"   # Cambia si quieres, o define $MODEL como env var
API="http://localhost:11434"

echo "[start] Starting Ollama service..."
ollama serve &

# Espera activa a que la API suba (máx ~60s)
echo "[start] Waiting for Ollama API..."
for i in $(seq 1 60); do
  if curl -sf "${API}/api/tags" >/dev/null 2>&1; then
    echo "[start] Ollama API is up."
    break
  fi
  sleep 1
  if [[ $i -eq 60 ]]; then
    echo "[start] ERROR: Ollama API did not start in time." >&2
    exit 1
  fi
done

# Verifica si el modelo ya está presente
if ollama list | awk '{print $1}' | grep -qx "${MODEL}"; then
  echo "[start] Model '${MODEL}' already present. Skipping pull."
else
  echo "[start] Pulling model '${MODEL}' (first time may take a while)..."
  # usa la API para que Render vea salida y no timeoutee
  curl -sS -X POST "${API}/api/pull" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${MODEL}\"}"
fi

# Warm-up: una generación corta, no streaming
echo "[start] Warming up model '${MODEL}'..."
curl -sS -X POST "${API}/api/generate" \
  -H "Content-Type: application/json" \
  -d "{\"model\":\"${MODEL}\",\"prompt\":\"hello\",\"stream\":false}" \
  >/dev/null || true

echo "[start] ✅ Ollama is ready with model '${MODEL}'."
# Mantén el contenedor vivo
tail -f /dev/null
``
