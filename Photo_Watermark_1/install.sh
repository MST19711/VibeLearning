#!/bin/bash

echo "Photo Watermark Tool - Installation Script"
echo "========================================="

# Check if Python 3 is installed
if command -v python3 &> /dev/null; then
    echo "✓ Python 3 found: $(python3 --version)"
else
    echo "✗ Python 3 not found. Please install Python 3.6 or higher."
    exit 1
fi

# Check if pip is installed
if command -v pip3 &> /dev/null; then
    echo "✓ pip3 found"
    PIP_CMD="pip3"
elif command -v pip &> /dev/null; then
    echo "✓ pip found"
    PIP_CMD="pip"
else
    echo "✗ pip not found. Please install pip."
    exit 1
fi

# Install dependencies
echo "Installing dependencies..."
$PIP_CMD install -r requirements.txt

if [ $? -eq 0 ]; then
    echo "✓ Dependencies installed successfully"
else
    echo "✗ Failed to install dependencies"
    exit 1
fi

# Make the script executable
chmod +x photo_watermark.py

echo ""
echo "Installation complete!"
echo ""
echo "Usage examples:"
echo "  python3 photo_watermark.py /path/to/photos"
echo "  python3 photo_watermark.py ./vacation_photos --font-size 64 --color red --position bottom-right"
echo ""
echo "For help: python3 photo_watermark.py --help"