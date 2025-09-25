import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/app_state.dart';

class OutputDirectorySelector extends StatelessWidget {
  const OutputDirectorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Output Directory',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                
                // Current directory display
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.folder, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          appState.outputDirectory.isEmpty
                              ? 'Same as input files (default)'
                              : appState.outputDirectory,
                          style: TextStyle(
                            color: appState.outputDirectory.isEmpty
                                ? Colors.grey.shade600
                                : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (appState.outputDirectory.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () => appState.setOutputDirectory(''),
                          tooltip: 'Clear directory',
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Directory selection buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _selectDirectory(context),
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Choose Directory'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => appState.setOutputDirectory(''),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Use Default'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Information text
                const SizedBox(height: 8),
                Text(
                  appState.outputDirectory.isEmpty
                      ? 'Watermarked images will be saved in the same directory as the original files with "_watermarked" suffix.'
                      : 'Watermarked images will be saved in the selected directory.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDirectory(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Output Directory',
    );

    if (result != null) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.setOutputDirectory(result);
    }
  }
}