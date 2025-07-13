# start_optimized.sh
#!/bin/bash

echo "Starting Ollama service..."
ollama serve &

# Wait longer for startup on free tier
echo "Waiting for Ollama to initialize..."
sleep 30

# Check if model exists before pulling
if ollama list | grep -q "GandalfBaum/deepseek_r1-claude3.7"; then
    echo "Model already exists, skipping download"
else
    echo "Downloading model (this may take a while on first run)..."
    ollama pull GandalfBaum/deepseek_r1-claude3.7
fi

# Preload the model
echo "Preloading model..."
ollama run GandalfBaum/deepseek_r1-claude3.7 "Hello" --verbose=false

echo "Ollama is ready!"
wait