import 'dart:math';
import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';

import '../../../../core/config/google_maps_config.dart';

class GooglePlacePrediction {
  final String placeId;
  final String primaryText;
  final String? secondaryText;

  const GooglePlacePrediction({
    required this.placeId,
    required this.primaryText,
    this.secondaryText,
  });
}

class GooglePlaceDetails {
  final String placeId;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;

  const GooglePlaceDetails({
    required this.placeId,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
  });
}

class GoogleGeocodedLocation {
  final String? placeId;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;

  const GoogleGeocodedLocation({
    this.placeId,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
  });
}

class GooglePlacesService {
  final Dio dio = Dio();

  static const String _autocompleteUrl =
      'https://places.googleapis.com/v1/places:autocomplete';

  static const String _placesBaseUrl =
      'https://places.googleapis.com/v1/places';

  String? _sessionToken;

  String _createSessionToken() {
    final random = Random();
    return List.generate(
      32,
          (_) => random.nextInt(16).toRadixString(16),
    ).join();
  }

  String get _currentSessionToken {
    return _sessionToken ??= _createSessionToken();
  }

  String _extractLocationName(
      Map<String, dynamic> result,
      String? formattedAddress,
      ) {
    final addressComponents =
    result['address_components'];

    if (addressComponents is List) {
      for (final component in addressComponents) {
        if (component is! Map<String, dynamic>) {
          continue;
        }

        final types = component['types'];

        if (types is List &&
            types.contains('point_of_interest')) {
          return component['long_name'] as String;
        }

        if (types is List &&
            types.contains('establishment')) {
          return component['long_name'] as String;
        }
      }
    }

    return formattedAddress ?? 'Selected location';
  }

  // Search places while the user types.
  Future<List<GooglePlacePrediction>> autocomplete(
      String input,
      ) async {
    final query = input.trim();

    if (query.isEmpty) {
      return [];
    }

    final apiKey = await GoogleMapsConfig.apiKey;

    final response = await dio.post(
      _autocompleteUrl,
      data: {
        'input': query,
        'sessionToken': _currentSessionToken,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': [
            'suggestions.placePrediction.placeId',
            'suggestions.placePrediction.text.text',
            'suggestions.placePrediction.structuredFormat.mainText.text',
            'suggestions.placePrediction.structuredFormat.secondaryText.text',
          ].join(','),
        },
      ),
    );

    debugPrint('Autocomplete status: ${response.statusCode}');
    debugPrint('Autocomplete response: ${response.data}');

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      return [];
    }

    final suggestions = data['suggestions'];

    if (suggestions is! List) {
      return [];
    }

    return suggestions
        .whereType<Map<String, dynamic>>()
        .map((suggestion) {
      final prediction =
      suggestion['placePrediction'] as Map<String, dynamic>?;

      if (prediction == null) {
        return null;
      }

      final placeId = prediction['placeId'] as String?;

      final structuredFormat =
      prediction['structuredFormat'] as Map<String, dynamic>?;

      final mainText =
      structuredFormat?['mainText'] as Map<String, dynamic>?;

      final secondaryText =
      structuredFormat?['secondaryText'] as Map<String, dynamic>?;

      final primaryText =
          mainText?['text'] as String? ??
              (prediction['text'] as Map<String, dynamic>?)?['text']
              as String?;

      if (placeId == null || primaryText == null) {
        return null;
      }

      return GooglePlacePrediction(
        placeId: placeId,
        primaryText: primaryText,
        secondaryText: secondaryText?['text'] as String?,
      );
    })
        .whereType<GooglePlacePrediction>()
        .toList();
  }

  Future<GoogleGeocodedLocation> reverseGeocode(
      double latitude,
      double longitude,
      ) async {
    final apiKey = await GoogleMapsConfig.apiKey;

    final response = await dio.get(
      'https://maps.googleapis.com/maps/api/geocode/json',
      queryParameters: {
        'latlng': '$latitude,$longitude',
        'key': apiKey,
      },
    );

    debugPrint('Reverse geocode status: ${response.statusCode}');
    debugPrint('Reverse geocode response: ${response.data}');

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid reverse geocoding response.');
    }

    final status = data['status'] as String?;

    if (status != 'OK') {
      throw Exception(
        'Reverse geocoding failed: ${data['status']}',
      );
    }

    final results = data['results'];

    if (results is! List || results.isEmpty) {
      throw Exception('No location found for these coordinates.');
    }

    final firstResult = results.first as Map<String, dynamic>;

    final formattedAddress =
    firstResult['formatted_address'] as String?;

    final placeId =
    firstResult['place_id'] as String?;

    final geometry =
    firstResult['geometry'] as Map<String, dynamic>?;

    final location =
    geometry?['location'] as Map<String, dynamic>?;

    final resultLat =
        (location?['lat'] as num?)?.toDouble() ?? latitude;

    final resultLng =
        (location?['lng'] as num?)?.toDouble() ?? longitude;

    final name = _extractLocationName(
      firstResult,
      formattedAddress,
    );

    return GoogleGeocodedLocation(
      placeId: placeId,
      name: name,
      address: formattedAddress,
      latitude: resultLat,
      longitude: resultLng,
    );
  }

  // Get the coordinates and full details for a selected place.
  Future<GooglePlaceDetails> getPlaceDetails(
      String placeId,
      ) async {
    final apiKey = await GoogleMapsConfig.apiKey;

    final response = await dio.get(
      '$_placesBaseUrl/$placeId',
      queryParameters: {
        'sessionToken': _currentSessionToken,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': [
            'id',
            'displayName',
            'formattedAddress',
            'location',
          ].join(','),
        },
      ),
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw Exception(
        'Invalid Google Place Details response.',
      );
    }

    final location =
    data['location'] as Map<String, dynamic>?;

    final latitude =
    (location?['latitude'] as num?)?.toDouble();

    final longitude =
    (location?['longitude'] as num?)?.toDouble();

    if (latitude == null || longitude == null) {
      throw Exception(
        'Selected place has no coordinates.',
      );
    }

    final displayName =
    data['displayName'] as Map<String, dynamic>?;

    final name =
        displayName?['text'] as String? ??
            'Unknown location';

    final address =
    data['formattedAddress'] as String?;

    final returnedPlaceId =
        data['id'] as String? ?? placeId;

    // End this autocomplete session.
    _sessionToken = null;

    return GooglePlaceDetails(
      placeId: returnedPlaceId,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void resetSession() {
    _sessionToken = null;
  }

}