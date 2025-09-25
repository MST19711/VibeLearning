import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/image_list.dart';
import '../widgets/watermark_controls.dart';
import '../widgets/process_button.dart';
import '../widgets/output_directory_selector.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Watermark'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAboutDialog(context),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image selection section
                _buildSectionTitle(context, 'Select Images'),
                const SizedBox(height: 8),
                const ImageList(),
                const SizedBox(height: 24),
                
                // Watermark settings section
                _buildSectionTitle(context, 'Watermark Settings'),
                const SizedBox(height: 8),
                const WatermarkControls(),
                const SizedBox(height: 24),
                
                // Output directory section
                _buildSectionTitle(context, 'Output Settings'),
                const SizedBox(height: 8),
                const OutputDirectorySelector(),
                const SizedBox(height: 32),
                
                // Process button
                Center(
                  child: ProcessButton(
                    onPressed: appState.selectedImages.isEmpty || appState.watermarkText.isEmpty
                        ? null
                        : () => _processImages(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future<void> _processImages(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    try {
      await appState.processImages();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Watermarking completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Photo Watermark'),
        content: const Text(
          'A simple cross-platform application for adding watermarks to photos.\n\n'
          'Features:\n'
          '• Select multiple images\n'
          '• Customizable text watermarks\n'
          '• Adjustable opacity, size, and color\n'
          '• Batch processing\n'
          '• Custom output directory',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}