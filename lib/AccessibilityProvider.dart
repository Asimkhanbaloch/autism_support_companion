import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider with ChangeNotifier {
  double _fontSize = 16.0;
  bool _highContrast = false;
  bool _vibrationFeedback = false;
  bool _textToSpeech = false;
  bool _animations = true;
  bool _screenReader = false;
  String _fontStyle = 'Sans';
  double _brightness = 1.0;

  double get fontSize => _fontSize;
  bool get highContrast => _highContrast;
  bool get vibrationFeedback => _vibrationFeedback;
  bool get textToSpeech => _textToSpeech;
  bool get animations => _animations;
  bool get screenReader => _screenReader;
  String get fontStyle => _fontStyle;
  double get brightness => _brightness;

  AccessibilityProvider() {
    _loadPreferences();
  }

  void setFontSize(double newSize) {
    _fontSize = newSize;
    _savePreferences();
    notifyListeners();
  }

  void toggleHighContrast() {
    _highContrast = !_highContrast;
    _savePreferences();
    notifyListeners();
  }

  void toggleVibrationFeedback() {
    _vibrationFeedback = !_vibrationFeedback;
    _savePreferences();
    notifyListeners();
  }

  void toggleTextToSpeech() {
    _textToSpeech = !_textToSpeech;
    _savePreferences();
    notifyListeners();
  }

  void toggleAnimations() {
    _animations = !_animations;
    _savePreferences();
    notifyListeners();
  }

  void toggleScreenReader() {
    _screenReader = !_screenReader;
    _savePreferences();
    notifyListeners();
  }

  void setFontStyle(String newStyle) {
    _fontStyle = newStyle;
    _savePreferences();
    notifyListeners();
  }

  void setBrightness(double newBrightness) {
    _brightness = newBrightness;
    _savePreferences();
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontSize', _fontSize);
    prefs.setBool('highContrast', _highContrast);
    prefs.setBool('vibrationFeedback', _vibrationFeedback);
    prefs.setBool('textToSpeech', _textToSpeech);
    prefs.setBool('animations', _animations);
    prefs.setBool('screenReader', _screenReader);
    prefs.setString('fontStyle', _fontStyle);
    prefs.setDouble('brightness', _brightness);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    _highContrast = prefs.getBool('highContrast') ?? false;
    _vibrationFeedback = prefs.getBool('vibrationFeedback') ?? false;
    _textToSpeech = prefs.getBool('textToSpeech') ?? false;
    _animations = prefs.getBool('animations') ?? true;
    _screenReader = prefs.getBool('screenReader') ?? false;
    _fontStyle = prefs.getString('fontStyle') ?? 'Sans';
    _brightness = prefs.getDouble('brightness') ?? 1.0;
    notifyListeners();
  }
}