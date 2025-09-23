# Photo Watermark Tool

A command-line tool to automatically add date watermarks to photos based on EXIF data.

## Features

- Extracts date information from EXIF data
- Supports multiple image formats (JPG, PNG, BMP, TIFF)
- Customizable font size and color
- Multiple positioning options (9 positions)
- Creates organized output directory structure
- Adds text outline for better visibility
- Modern UV-based dependency management for fast and reliable installations

## Installation

### Using UV (Recommended)

[UV](https://github.com/astral-sh/uv) is a fast Python package installer and resolver that provides better performance than pip.

1. **Install UV** (if not already installed):
   ```bash
   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   
   # Or using Homebrew (macOS)
   brew install uv
   
   # Or using pip
   pip install uv
   ```

2. **Install dependencies and setup project**:
   ```bash
   # Using the provided installation script
   ./install_uv.sh
   
   # Or manually
   uv sync
   ```

### Traditional Method (Using pip)

1. Install Python 3.8 or higher
2. Install required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

### Using UV (Recommended)

After installing with UV, you can run the tool in several ways:

**Option 1: Using `uv run` (recommended)**
```bash
# Basic usage
uv run photo_watermark.py /path/to/photos

# With options
uv run photo_watermark.py /path/to/photos --font-size 64 --color red --position bottom-right

# Run from any directory
uv run --directory /path/to/project photo_watermark.py /path/to/photos
```

**Option 2: Activate virtual environment**
```bash
# Activate the virtual environment
source .venv/bin/activate

# Then use normally
python photo_watermark.py /path/to/photos
```

### Traditional Method (Using pip)

Basic usage:
```bash
python photo_watermark.py /path/to/photos
```

With options:
```bash
python photo_watermark.py /path/to/photos --font-size 64 --color red --position bottom-right
```

### Command Line Arguments

- `input_dir`: Directory containing photos to watermark (required)
- `--font-size`: Font size for watermark (default: 48)
- `--color`: Watermark color options:
  - Named colors: white, black, red, green, blue, yellow, cyan, magenta
  - Hex color: #FF0000 (red)
  - RGB format: rgb(255,0,0) (red)
- `--position`: Watermark position (default: bottom-right):
  - top-left, top-center, top-right
  - center
  - bottom-left, bottom-center, bottom-right

### Examples

**Using UV:**

1. White watermark in top-left corner:
   ```bash
   uv run photo_watermark.py ./vacation_photos --position top-left --color white
   ```

2. Large red watermark in center:
   ```bash
   uv run photo_watermark.py ./wedding_photos --font-size 72 --color red --position center
   ```

3. Custom blue color with hex code:
   ```bash
   uv run photo_watermark.py ./family_photos --color "#0066CC" --font-size 36
   ```

**Using traditional pip:**

1. White watermark in top-left corner:
   ```bash
   python photo_watermark.py ./vacation_photos --position top-left --color white
   ```

2. Large red watermark in center:
   ```bash
   python photo_watermark.py ./wedding_photos --font-size 72 --color red --position center
   ```

3. Custom blue color with hex code:
   ```bash
   python photo_watermark.py ./family_photos --color "#0066CC" --font-size 36
   ```

## Output

- Creates a new directory named `{original_directory}_watermark` as a subdirectory
- Processes all supported image files in the input directory
- Skips files without EXIF date information
- Maintains original filenames in the output directory

## Supported Image Formats

- JPEG (.jpg, .jpeg)
- PNG (.png)
- BMP (.bmp)
- TIFF (.tiff, .tif)

## How It Works

1. Scans the specified directory for image files
2. Extracts date information from EXIF data (DateTimeOriginal, DateTime, or DateTimeDigitized)
3. Formats the date as YYYY-MM-DD
4. Adds the date as a watermark to each image
5. Saves watermarked images to a new directory

## Notes

- The tool will skip images without EXIF date information
- Watermarks include a subtle outline for better visibility on various backgrounds
- Font size is automatically scaled based on image dimensions
- The tool preserves image quality with 95% JPEG quality for JPG files

## Error Handling

- Invalid directories will display an error message
- Images without EXIF data will be skipped with a notification
- Corrupted image files will be reported and skipped
- Missing fonts will fall back to system default fonts

## Project Structure

```
photo-watermark/
├── photo_watermark.py      # Main script
├── pyproject.toml          # UV project configuration
├── uv.lock                 # Locked dependencies
├── requirements.txt        # Traditional pip requirements (fallback)
├── install_uv.sh          # UV installation script
├── install.sh             # Traditional pip installation script
├── README.md              # This file
└── example_photos/        # Example photos for testing
```

## Why UV?

[UV](https://github.com/astral-sh/uv) provides several advantages over traditional pip:

- **Speed**: 10-100x faster dependency resolution and installation
- **Reliability**: Consistent dependency resolution with lock files
- **Space Efficient**: Shared cache across projects
- **Modern**: Built-in virtual environment management
- **Cross-platform**: Works on Windows, macOS, and Linux

## Development

If you want to contribute or modify this tool:

1. **Setup development environment**:
   ```bash
   uv sync --extra dev
   ```

2. **Run with development dependencies**:
   ```bash
   uv run --extra dev photo_watermark.py /path/to/photos
   ```

3. **Format code**:
   ```bash
   uv run black photo_watermark.py
   ```

4. **Run tests** (if implemented):
   ```bash
   uv run pytest
   ```