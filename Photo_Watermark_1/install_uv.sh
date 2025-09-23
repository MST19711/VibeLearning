#!/bin/bash

echo "Photo Watermark Tool - UV Installation Script"
echo "==========================================="

# Check if Python 3 is installed
if command -v python3 &> /dev/null; then
    echo "✓ Python 3 found: $(python3 --version)"
else
    echo "✗ Python 3 not found. Please install Python 3.8 or higher."
    exit 1
fi

# Check if uv is installed
if command -v uv &> /dev/null; then
    echo "✓ uv found: $(uv --version)"
else
    echo "✗ uv not found. Installing uv..."
    if command -v curl &> /dev/null; then
        curl -LsSf https://astral.sh/uv/install.sh | sh
        # Add uv to PATH for current session
        export PATH="$HOME/.cargo/bin:$PATH"
    else
        echo "✗ curl not found. Please install uv manually from https://github.com/astral-sh/uv"
        exit 1
    fi
fi

# Verify uv is available
if ! command -v uv &> /dev/null; then
    echo "✗ uv installation failed. Please install uv manually."
    exit 1
fi

echo "Installing project dependencies with uv..."
uv sync

if [ $? -eq 0 ]; then
    echo "✓ Dependencies installed successfully"
else
    echo "✗ Failed to install dependencies"
    exit 1
fi

echo ""
echo "Installation complete!"
echo ""
echo "Usage examples:"
echo "  uv run photo_watermark.py /path/to/photos"
echo "  uv run photo_watermark.py ./vacation_photos --font-size 64 --color red --position bottom-right"
echo "  uv run --directory example_photos ../photo_watermark.py . --font-size 48 --color white"
echo ""
echo "Or activate the virtual environment:"
echo "  source .venv/bin/activate"
echo "  python photo_watermark.py /path/to/photos"
echo ""
echo "For help: uv run photo_watermark.py --help"