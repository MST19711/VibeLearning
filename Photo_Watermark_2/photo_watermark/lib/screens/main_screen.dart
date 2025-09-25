import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/image_list.dart';
import '../widgets/watermark_controls.dart';
import '../widgets/output_directory_selector.dart';
import '../widgets/real_time_preview.dart';
import '../widgets/nine_grid_position_selector.dart';
import '../widgets/rotation_control.dart';

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
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left panel - Controls
              SizedBox(
                width: 350,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ImageList(),
                      const SizedBox(height: 16),
                      const WatermarkControls(),
                      const SizedBox(height: 16),
                      const NineGridPositionSelector(),
                      const SizedBox(height: 16),
                      const RotationControl(),
                      const SizedBox(height: 16),
                      const OutputDirectorySelector(),
                      const SizedBox(height: 24),
                      _buildProcessButton(context),
                    ],
                  ),
                ),
              ),
              
              // Right panel - Preview
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const RealTimePreview(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProcessButton(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: appState.selectedImages.isEmpty || appState.watermarkText.isEmpty
                ? null
                : () => _processImages(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: appState.isProcessing
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Processing...'),
                    ],
                  )
                : const Text('Process Images'),
          ),
        );
      },
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