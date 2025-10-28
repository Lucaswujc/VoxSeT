#!/bin/bash
# Restore original CUDA environment
echo "Restoring original CUDA environment..."

if [ -n "${OLD_CUDA_HOME:-}" ]; then
    export CUDA_HOME="$OLD_CUDA_HOME"
else
    unset CUDA_HOME
fi

if [ -n "${OLD_LD_LIBRARY_PATH:-}" ]; then
    export LD_LIBRARY_PATH="$OLD_LD_LIBRARY_PATH"
else
    unset LD_LIBRARY_PATH
fi

export PATH="$OLD_PATH"

unset OLD_CUDA_HOME OLD_LD_LIBRARY_PATH OLD_PATH
unset CUDA_ROOT

echo "✅ Original environment restored"
if command -v nvcc >/dev/null 2>&1; then
    echo "   Current CUDA: $(nvcc --version | grep -o 'release [0-9]*\.[0-9]*' | cut -d' ' -f2)"
fi
