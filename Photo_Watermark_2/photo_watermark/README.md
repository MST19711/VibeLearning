# Photo Watermark

A cross-platform GUI application for adding watermarks to photos, built with Flutter.

## Features

- **Batch Processing**: Add watermarks to multiple photos at once
- **Customizable Watermarks**:
  - Text-based watermarks with custom text
  - Adjustable opacity (0-100%)
  - Variable size control
  - Color picker for text color
  - 9 predefined positions (top-left, top-center, top-right, middle-left, center, middle-right, bottom-left, bottom-center, bottom-right)
- **File Management**:
  - Select multiple image files
  - Choose output directory or save to same location as input
  - Support for common image formats
- **User-Friendly Interface**:
  - Clean and intuitive design
  - Real-time preview of watermark settings
  - Progress indication during processing
  - About dialog with app information

## Screenshots

*Screenshots will be added here*

## Installation

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Xcode (for macOS development)
- Git

### Build from Source

1. Clone the repository:
```bash
git clone https://github.com/yourusername/photo_watermark.git
cd photo_watermark
```

2. Install dependencies:
```bash
flutter pub get
```

3. Build for your platform:

#### macOS
```bash
flutter build macos --release
```

The built application will be available at `build/macos/Build/Products/Release/photo_watermark.app`

#### Other Platforms
```bash
# Windows
flutter build windows --release

# Linux
flutter build linux --release

# Web
flutter build web --release
```

## Usage

1. Launch the application
2. Click "Add Images" to select photos you want to watermark
3. Configure your watermark settings:
   - Enter watermark text
   - Adjust opacity using the slider
   - Set text size
   - Choose text color
   - Select watermark position
4. Choose output directory (optional - defaults to input file location)
5. Click "Process Images" to add watermarks
6. Find your watermarked images in the output directory

## Development

### Project Structure

```
lib/
├── main.dart                    # Main application entry point
├── models/
│   └── app_state.dart          # State management using Provider
├── screens/
│   └── main_screen.dart        # Main application screen
└── widgets/
    ├── image_list.dart         # Image selection and display
    ├── watermark_controls.dart # Watermark configuration controls
    ├── output_directory_selector.dart # Output directory selection
    └── process_button.dart     # Process button widget
```

### Key Dependencies

- `flutter`: UI framework
- `provider`: State management
- `image`: Image processing and watermarking
- `file_picker`: File selection dialog
- `path_provider`: File system access

### Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the excellent framework
- Image processing library contributors
- File picker package maintainers

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.

---

**Made with ❤️ using Flutter**
