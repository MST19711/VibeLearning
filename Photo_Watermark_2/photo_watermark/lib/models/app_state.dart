import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class AppState extends ChangeNotifier {
  List<File> _selectedImages = [];
  String _watermarkText = '';
  double _watermarkOpacity = 0.5;
  double _watermarkSize = 24;
  Color _watermarkColor = Colors.white;
  Offset _watermarkPosition = const Offset(10, 10);
  bool _isProcessing = false;
  String _outputDirectory = '';

  List<File> get selectedImages => _selectedImages;
  String get watermarkText => _watermarkText;
  double get watermarkOpacity => _watermarkOpacity;
  double get watermarkSize => _watermarkSize;
  Color get watermarkColor => _watermarkColor;
  Offset get watermarkPosition => _watermarkPosition;
  bool get isProcessing => _isProcessing;
  String get outputDirectory => _outputDirectory;

  void addImages(List<File> images) {
    _selectedImages.addAll(images);
    notifyListeners();
  }

  void removeImage(int index) {
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  void clearImages() {
    _selectedImages.clear();
    notifyListeners();
  }

  void setWatermarkText(String text) {
    _watermarkText = text;
    notifyListeners();
  }

  void setWatermarkOpacity(double opacity) {
    _watermarkOpacity = opacity;
    notifyListeners();
  }

  void setWatermarkSize(double size) {
    _watermarkSize = size;
    notifyListeners();
  }

  void setWatermarkColor(Color color) {
    _watermarkColor = color;
    notifyListeners();
  }

  void setWatermarkPosition(Offset position) {
    _watermarkPosition = position;
    notifyListeners();
  }

  void setOutputDirectory(String directory) {
    _outputDirectory = directory;
    notifyListeners();
  }

  Future<void> processImages() async {
    if (_selectedImages.isEmpty || _watermarkText.isEmpty) return;

    _isProcessing = true;
    notifyListeners();

    try {
      for (var imageFile in _selectedImages) {
        final bytes = await imageFile.readAsBytes();
        final image = img.decodeImage(bytes);
        
        if (image != null) {
          final watermarkedImage = _addWatermarkToImage(image);
          final outputPath = _getOutputPath(imageFile.path);
          
          final outputFile = File(outputPath);
          await outputFile.writeAsBytes(img.encodeJpg(watermarkedImage));
        }
      }
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  img.Image _addWatermarkToImage(img.Image image) {
    final watermarked = img.copyResize(image, width: image.width, height: image.height);
    
    // Convert Flutter Color to RGB values
    final red = _watermarkColor.red;
    final green = _watermarkColor.green;
    final blue = _watermarkColor.blue;
    
    // Add text watermark
    img.drawString(
      watermarked,
      _watermarkText,
      font: img.arial24,
      x: _watermarkPosition.dx.toInt(),
      y: _watermarkPosition.dy.toInt(),
      color: img.ColorRgba8(red, green, blue, (_watermarkOpacity * 255).toInt()),
    );
    
    return watermarked;
  }

  String _getOutputPath(String originalPath) {
    final fileName = originalPath.split('/').last;
    final nameWithoutExtension = fileName.split('.').first;
    final extension = fileName.split('.').last;
    
    String outputPath;
    if (_outputDirectory.isNotEmpty) {
      outputPath = '$_outputDirectory/${nameWithoutExtension}_watermarked.$extension';
    } else {
      outputPath = originalPath.replaceAll(fileName, '${nameWithoutExtension}_watermarked.$extension');
    }
    
    return outputPath;
  }
}