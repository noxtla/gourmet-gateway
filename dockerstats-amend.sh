#!/bin/bash

# Este script captura una instantánea de las estadísticas de Docker y las añade a un archivo de registro.

# Añade una marca de tiempo al archivo de registro para separar las capturas.
echo "--- Stats captured at: $(date) ---" >> docker-stats-log.txt

# Ejecuta docker stats, --no-stream asegura que el comando se ejecute una vez y termine.
# La salida se añade (>>) al archivo de registro.
docker stats --no-stream >> docker-stats-log.txt

# Añade una línea en blanco para una mejor legibilidad entre capturas.
echo "" >> docker-stats-log.txt

echo "Instantánea de Docker stats guardada en docker-stats-log.txt"
