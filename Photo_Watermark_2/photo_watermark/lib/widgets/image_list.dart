import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/app_state.dart';

class ImageList extends StatelessWidget {
  const ImageList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Column(
          children: [
            // Add images button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pickImages(context),
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add Images'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Selected images list
            if (appState.selectedImages.isNotEmpty) ...[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    // Header with clear button
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${appState.selectedImages.length} image(s) selected',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: () => appState.clearImages(),
                            icon: const Icon(Icons.clear, size: 16),
                            label: const Text('Clear All'),
                          ),
                        ],
                      ),
                    ),
                    // Image list
                    Expanded(
                      child: ListView.builder(
                        itemCount: appState.selectedImages.length,
                        itemBuilder: (context, index) {
                          final image = appState.selectedImages[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.image, size: 40),
                              title: Text(
                                image.path.split('/').last,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(_formatFileSize(image)),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () => appState.removeImage(index),
                              ),
                              selected: index == appState.currentPreviewIndex,
                              selectedTileColor: Colors.blue.shade50,
                              onTap: () {
                                appState.setCurrentPreviewIndex(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library,
                      size: 48,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No images selected',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Click "Add Images" to select photos',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _pickImages(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      if (context.mounted) {
        final appState = Provider.of<AppState>(context, listen: false);
        final images = result.paths.map((path) => File(path!)).toList();
        appState.addImages(images);
      }
    }
  }

  String _formatFileSize(File file) {
    try {
      final sizeInBytes = file.lengthSync();
      if (sizeInBytes < 1024) return '${sizeInBytes}B';
      if (sizeInBytes < 1024 * 1024) return '${(sizeInBytes / 1024).toStringAsFixed(1)}KB';
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } catch (e) {
      return 'Unknown size';
    }
  }
}