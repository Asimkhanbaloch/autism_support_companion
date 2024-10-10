import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AccessibilityProvider.dart';

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AccessibilityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Accessibility Settings", style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Font Size Adjustment
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Font Size", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Slider(
                          value: provider.fontSize,
                          min: 14.0,
                          max: 30.0,
                          onChanged: (newValue) {
                            provider.setFontSize(newValue);
                          },
                        ),
                      ),
                      Text(provider.fontSize.toStringAsFixed(0), style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),

              // Text-to-Speech
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  title: const Text("Text-to-Speech", style: TextStyle(fontSize: 18)),
                  value: provider.textToSpeech,
                  onChanged: (value) {
                    provider.toggleTextToSpeech();
                  },
                ),
              ),

              // Animations
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  title: const Text("Disable Animations", style: TextStyle(fontSize: 18)),
                  value: !provider.animations,
                  onChanged: (value) {
                    provider.toggleAnimations();
                  },
                ),
              ),

              // Screen Reader Support
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: SwitchListTile(
                  title: const Text("Enable Screen Reader", style: TextStyle(fontSize: 18)),
                  value: provider.screenReader,
                  onChanged: (value) {
                    provider.toggleScreenReader();
                  },
                ),
              ),

              // Font Style Selector
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: const Text("Font Style", style: TextStyle(fontSize: 18)),
                  trailing: DropdownButton<String>(
                    value: provider.fontStyle,
                    items: const [
                      DropdownMenuItem(value: 'Sans', child: Text('Sans')),
                      DropdownMenuItem(value: 'Serif', child: Text('Serif')),
                      DropdownMenuItem(value: 'Monospace', child: Text('Monospace')),
                    ],
                    onChanged: (String? newStyle) {
                      if (newStyle != null) {
                        provider.setFontStyle(newStyle);
                      }
                    },
                  ),
                ),
              ),

              // Brightness Adjustment
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Brightness", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Slider(
                          value: provider.brightness,
                          min: 0.1,
                          max: 1.0,
                          onChanged: (newValue) {
                            provider.setBrightness(newValue);
                          },
                        ),
                      ),
                      Text("${(provider.brightness * 100).toInt()}%", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
