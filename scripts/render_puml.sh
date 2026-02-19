#!/usr/bin/env bash
set -euo pipefail

# Renders docs/ARCHITECTURE.puml to assets/docs/architecture.png using PlantUML Docker image.
# Usage: ./scripts/render_puml.sh

PUML_SRC="docs/ARCHITECTURE.puml"
OUT_DIR="assets/docs"
OUT_PNG="$OUT_DIR/architecture.png"

mkdir -p "$OUT_DIR"

if [ ! -f "$PUML_SRC" ]; then
  echo "PlantUML source $PUML_SRC not found."
  exit 0
fi

docker run --rm -v "$(pwd)":/workspace plantuml/plantuml:latest -tpng "/workspace/$PUML_SRC" -o "/workspace/$OUT_DIR"

echo "Rendered $PUML_SRC -> $OUT_PNG"
