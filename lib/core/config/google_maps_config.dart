import 'package:flutter/services.dart';

class GoogleMapsConfig {
  static const MethodChannel _channel =
  MethodChannel('com.example.movem/google_config');

  static String? _apiKey;

  static Future<String> get apiKey async {
    if (_apiKey != null) {
      return _apiKey!;
    }

    final key = await _channel.invokeMethod<String>('getMapsApiKey');

    if (key == null || key.isEmpty) {
      throw Exception('Google Maps API key is not available.');
    }

    _apiKey = key;
    return key;
  }
}