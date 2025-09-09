#!/bin/bash

# Nombre del archivo de salida
OUTPUT_FILE="output.md"

# Ejecuta docker-compose con build, convierte la salida a Markdown y guarda/visualiza
docker-compose up --build 2>&1 \
  | sed 's/^=/>## /; s/^\[+]/# &/; s/^/- /' \
  | tee "$OUTPUT_FILE"

echo ""
echo "✅ Logs guardados en $OUTPUT_FILE"
