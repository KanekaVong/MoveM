import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/config/google_maps_config.dart';

class GoogleRouteResult {
  final List<LatLng> points;
  final int distanceMeters;
  final String duration;

  const GoogleRouteResult({
    required this.points,
    required this.distanceMeters,
    required this.duration,
  });
}

class GoogleRoutesService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static const String _routesUrl =
      'https://routes.googleapis.com/directions/v2:computeRoutes';

  Future<GoogleRouteResult> calculateRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng> intermediates = const [],
  }) async {
    final apiKey = await GoogleMapsConfig.apiKey;

    final response = await dio.post(
      _routesUrl,
      data: {
        'origin': _location(origin),
        'destination': _location(destination),
        'intermediates': intermediates
            .map(_location)
            .toList(),
        'travelMode': 'DRIVE',
        'routingPreference': 'TRAFFIC_AWARE',
        'computeAlternativeRoutes': false,
        'routeModifiers': {
          'avoidTolls': false,
          'avoidHighways': false,
          'avoidFerries': false,
        },
        'languageCode': 'en-US',
        'units': 'METRIC',
        'polylineQuality': 'OVERVIEW',
        'polylineEncoding': 'ENCODED_POLYLINE',
      },
      options: Options(
        headers: {
          'Authorization': null,
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask': [
            'routes.distanceMeters',
            'routes.duration',
            'routes.polyline.encodedPolyline',
          ].join(','),
        },
      ),
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid Routes API response.');
    }

    final routes = data['routes'];

    if (routes is! List || routes.isEmpty) {
      throw Exception('No route found.');
    }

    final route = routes.first as Map<String, dynamic>;

    final encodedPolyline =
    (route['polyline']
    as Map<String, dynamic>?)?['encodedPolyline']
    as String?;

    if (encodedPolyline == null ||
        encodedPolyline.isEmpty) {
      throw Exception('Route polyline was not returned.');
    }

    final distanceMeters =
        (route['distanceMeters'] as num?)?.toInt() ?? 0;

    final duration =
        route['duration'] as String? ?? '0s';

    return GoogleRouteResult(
      points: _decodePolyline(encodedPolyline),
      distanceMeters: distanceMeters,
      duration: duration,
    );
  }

  Map<String, dynamic> _location(LatLng point) {
    return {
      'location': {
        'latLng': {
          'latitude': point.latitude,
          'longitude': point.longitude,
        },
      },
    };
  }

  List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];

    int index = 0;
    int latitude = 0;
    int longitude = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;

      int byte;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final deltaLatitude =
      (result & 1) != 0
          ? ~(result >> 1)
          : (result >> 1);

      latitude += deltaLatitude;

      shift = 0;
      result = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final deltaLongitude =
      (result & 1) != 0
          ? ~(result >> 1)
          : (result >> 1);

      longitude += deltaLongitude;

      points.add(
        LatLng(
          latitude / 100000.0,
          longitude / 100000.0,
        ),
      );
    }

    return points;
  }
}