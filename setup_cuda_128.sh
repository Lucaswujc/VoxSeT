#!/bin/bash
# Temporary CUDA 12.8 Environment Setup Script
# Usage: source set_cuda11.sh

echo "Setting up temporary CUDA 12.8 environment..."

# Save current environment variables
export OLD_CUDA_HOME="${CUDA_HOME:-}"
export OLD_LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}"
export OLD_PATH="${PATH}"

# Common CUDA 12.8 installation paths (adjust if needed)
CUDA_12_8_PATHS=(
    "/usr/local/cuda-12.8"
    "/opt/cuda-12.8" 
    "/usr/local/cuda-11"
    "/opt/cuda-11"
)

# Find CUDA 12.8 installation
CUDA_PATH=""
for path in "${CUDA_12_8_PATHS[@]}"; do
    if [ -d "$path" ] && [ -f "$path/bin/nvcc" ]; then
        CUDA_PATH="$path"
        break
    fi
done

if [ -z "$CUDA_PATH" ]; then
    echo "❌ CUDA 12.8 not found in common locations!"
    echo "Available CUDA installations:"
    ls -la /usr/local/cuda* 2>/dev/null | grep -E "(cuda-11|cuda$)" || echo "  None found in /usr/local/"
    ls -la /opt/cuda* 2>/dev/null | grep -E "(cuda-11|cuda$)" || echo "  None found in /opt/"
    echo ""
    echo "Please manually set CUDA_PATH:"
    echo "  export CUDA_PATH=/path/to/your/cuda-12.8"
    echo "  source set_cuda11.sh"
    return 1
fi

# Set CUDA 12.8 environment variables
export CUDA_HOME="$CUDA_PATH"
export CUDA_ROOT="$CUDA_PATH"
export PATH="$CUDA_PATH/bin:$PATH"
export LD_LIBRARY_PATH="$CUDA_PATH/lib64:${LD_LIBRARY_PATH}"

echo "✅ CUDA 12.8 environment configured!"
echo "   CUDA_HOME: $CUDA_HOME"

# Verify CUDA version
if command -v nvcc >/dev/null 2>&1; then
    echo "   CUDA Version: $(nvcc --version | grep -o 'release [0-9]*\.[0-9]*' | cut -d' ' -f2)"
else
    echo "⚠️  Warning: nvcc not found in PATH"
fi

echo ""
echo "To restore original environment, run:"
echo "  source restore_cuda.sh"

# Create restore script
cat > restore_cuda.sh << 'EOF'
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
EOF

chmod +x restore_cuda.sh
