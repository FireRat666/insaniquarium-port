#!/usr/bin/env bash
# setup.sh - Initialise submodules and generate port sources for clean clones.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo "== 1. Initialising submodules =="
git submodule init
git submodule update poplib external/winfish

# Disable the dead discordrpc submodule in poplib (upstream repo deleted by author)
if [ -d "poplib" ]; then
    git -C poplib config submodule.external/discordrpc.update none 2>/dev/null || true
fi

echo "== 2. Checking out submodules recursively =="
git submodule update --init --recursive

echo "== 3. Ensuring build dependencies exist =="
# libopenmpt requires svn_version.h which is ignored by poplib/.gitignore
mkdir -p poplib/external/libopenmpt/build/svn_version
touch poplib/external/libopenmpt/build/svn_version/svn_version.h

echo "== 4. Generating port sources =="
bash port/port.sh

echo
echo "== Setup complete! =="
echo "Next steps:"
echo "  1. Copy your game assets:  bash port/copy-assets.sh /path/to/'Insaniquarium Deluxe'"
echo "  2. Fix asset case-names:   python3 port/verify-assets.py --fix-case"
echo "  3. Build the game:         cmake -B build port && cmake --build build -j\$(nproc)"
