import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class WatermarkControls extends StatelessWidget {
  const WatermarkControls({super.key});

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
                // Watermark text input
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Watermark Text',
                    hintText: 'Enter your watermark text',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.text_fields),
                  ),
                  onChanged: (text) => appState.setWatermarkText(text),
                ),
                const SizedBox(height: 16),
                
                // Opacity slider
                _buildSliderControl(
                  context,
                  'Opacity',
                  appState.watermarkOpacity,
                  0.0,
                  1.0,
                  (value) => appState.setWatermarkOpacity(value),
                  '${(appState.watermarkOpacity * 100).toStringAsFixed(0)}%',
                ),
                const SizedBox(height: 16),
                
                // Size slider
                _buildSliderControl(
                  context,
                  'Size',
                  appState.watermarkSize,
                  12.0,
                  72.0,
                  (value) => appState.setWatermarkSize(value),
                  appState.watermarkSize.toStringAsFixed(0),
                ),
                const SizedBox(height: 16),
                
                // Color picker
                _buildColorControl(context, appState),
                const SizedBox(height: 16),
                
                // Position controls
                _buildPositionControl(context, appState),
                const SizedBox(height: 16),
                
                // Preview section
                _buildPreviewSection(context, appState),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliderControl(
    BuildContext context,
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged,
    String valueText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            Text(valueText, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildColorControl(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Color', style: TextStyle(fontSize: 16)),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: appState.watermarkColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Colors.white,
            Colors.black,
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
            Colors.purple,
            Colors.orange,
          ].map((color) => GestureDetector(
            onTap: () => appState.setWatermarkColor(color),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: appState.watermarkColor == color 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey,
                  width: appState.watermarkColor == color ? 3 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildPositionControl(BuildContext context, AppState appState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Position', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        LayoutBuilder(
                  builder: (context, constraints) {
                    final buttonWidth = (constraints.maxWidth - 32) / 5;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: buttonWidth,
                          child: _buildPositionButton(context, appState, 'Top Left', const Offset(10, 10)),
                        ),
                        SizedBox(
                          width: buttonWidth,
                          child: _buildPositionButton(context, appState, 'Top Right', const Offset(-10, 10)),
                        ),
                        SizedBox(
                          width: buttonWidth,
                          child: _buildPositionButton(context, appState, 'Bottom Left', const Offset(10, -10)),
                        ),
                        SizedBox(
                          width: buttonWidth,
                          child: _buildPositionButton(context, appState, 'Bottom Right', const Offset(-10, -10)),
                        ),
                        SizedBox(
                          width: buttonWidth,
                          child: _buildPositionButton(context, appState, 'Center', const Offset(0, 0)),
                        ),
                      ],
                    );
                  },
                ),
      ],
    );
  }

  Widget _buildPositionButton(
    BuildContext context,
    AppState appState,
    String label,
    Offset position,
  ) {
    final isSelected = _isPositionSelected(appState.watermarkPosition, position);
    
    return ElevatedButton(
      onPressed: () => appState.setWatermarkPosition(position),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade200,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        minimumSize: const Size(0, 30),
      ),
      child: Text(label, style: const TextStyle(fontSize: 9)),
    );
  }

  bool _isPositionSelected(Offset current, Offset target) {
    // Simple position matching logic
    if (target.dx == 0 && target.dy == 0) {
      return current.dx == 0 && current.dy == 0;
    }
    return (current.dx - target.dx).abs() < 5 && (current.dy - target.dy).abs() < 5;
  }

  Widget _buildPreviewSection(BuildContext context, AppState appState) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Real-time Preview',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        // The preview will be integrated in the main screen layout
      ],
    );
  }
}