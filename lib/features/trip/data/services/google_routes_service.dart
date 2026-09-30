import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
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

  String _toGoogleTravelMode(String mode) {
    switch (mode) {
      case 'DRIVING':
        return 'DRIVE';

      case 'WALKING':
        return 'WALK';

      case 'CYCLING':
        return 'BICYCLE';

      case 'RIDING':
        return 'TWO_WHEELER';

      default:
        return 'DRIVE';
    }
  }

  Future<GoogleRouteResult> calculateRoute({
    required LatLng origin,
    required LatLng destination,
    List<LatLng> intermediates = const [],
    String travelMode = 'DRIVING',
  }) async {
    final apiKey = await GoogleMapsConfig.apiKey;

    final googleTravelMode =
    _toGoogleTravelMode(travelMode);

    final requestData = <String, dynamic>{
      'origin': _location(origin),
      'destination': _location(destination),
      'intermediates': intermediates
          .map(_location)
          .toList(),
      'travelMode': googleTravelMode,
      'computeAlternativeRoutes': false,
      'languageCode': 'en-US',
      'units': 'METRIC',
      'polylineQuality': 'OVERVIEW',
      'polylineEncoding': 'ENCODED_POLYLINE',
    };

    if (googleTravelMode == 'DRIVE' ||
        googleTravelMode == 'TWO_WHEELER') {
      requestData['routingPreference'] = 'TRAFFIC_AWARE';

      requestData['routeModifiers'] = {
        'avoidTolls': false,
        'avoidHighways': false,
        'avoidFerries': false,
      };
    }

    Response response;

    try {
      response = await dio.post(
        _routesUrl,
        data: requestData,
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
    } on DioException catch (e) {
      debugPrint('GOOGLE ROUTES ERROR');
      debugPrint('STATUS: ${e.response?.statusCode}');
      debugPrint('DATA: ${e.response?.data}');
      debugPrint('REQUEST: ${e.requestOptions.data}');
      rethrow;
    }

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
      points: decodePolyline(encodedPolyline),
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

  List<LatLng> decodePolyline(String encoded) {
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