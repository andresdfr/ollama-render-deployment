# start.sh
#!/bin/bash

# Start Ollama in background
ollama serve &

# Wait for Ollama to be ready
sleep 10

# Pull the model (adjust model name as needed)
echo "Pulling DeepSeek R1-Claude 3.7 model..."
ollama pull GandalfBaum/deepseek_r1-claude3.7

# Alternative smaller models for testing:
# ollama pull llama3.2:3b
# ollama pull gemma2:2b
# ollama pull codellama:7b

# Keep the container running
echo "Ollama is ready and serving on port 11434"
wait