#!/usr/bin/env bash
# Configure and build the ported game for desktop Linux (x86_64).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --parallel

echo
echo "Build complete! Output binary is at: $ROOT/bin/Insaniquarium"
