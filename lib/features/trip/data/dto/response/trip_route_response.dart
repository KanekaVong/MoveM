class TripRouteStopResponse {
  final int? sequenceOrder;
  final String? locationName;
  final double? lat;
  final double? lng;
  final double? distanceFromPreviousKm;
  final int? estimatedTravelTimeMinutes;

  TripRouteStopResponse({
    this.sequenceOrder,
    this.locationName,
    this.lat,
    this.lng,
    this.distanceFromPreviousKm,
    this.estimatedTravelTimeMinutes,
  });

  factory TripRouteStopResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return TripRouteStopResponse(
      sequenceOrder: json['sequenceOrder'] is int
          ? json['sequenceOrder']
          : int.tryParse(
        json['sequenceOrder']?.toString() ?? '',
      ),
      locationName: json['locationName']?.toString(),
      lat: json['lat'] != null
          ? double.tryParse(json['lat'].toString())
          : null,
      lng: json['lng'] != null
          ? double.tryParse(json['lng'].toString())
          : null,
      distanceFromPreviousKm:
      json['distanceFromPreviousKm'] != null
          ? double.tryParse(
        json['distanceFromPreviousKm'].toString(),
      )
          : null,
      estimatedTravelTimeMinutes:
      json['estimatedTravelTimeMinutes'] is int
          ? json['estimatedTravelTimeMinutes']
          : int.tryParse(
        json['estimatedTravelTimeMinutes']
            ?.toString() ??
            '',
      ),
    );
  }
}

class TripRouteSegmentResponse {
  final int? sequenceOrder;
  final String? from;
  final String? to;
  final double? distanceKm;
  final int? estimatedTravelTimeMinutes;

  TripRouteSegmentResponse({
    this.sequenceOrder,
    this.from,
    this.to,
    this.distanceKm,
    this.estimatedTravelTimeMinutes,
  });

  factory TripRouteSegmentResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return TripRouteSegmentResponse(
      sequenceOrder: json['sequenceOrder'] is int
          ? json['sequenceOrder']
          : int.tryParse(
        json['sequenceOrder']?.toString() ?? '',
      ),
      from: json['from']?.toString(),
      to: json['to']?.toString(),
      distanceKm: json['distanceKm'] != null
          ? double.tryParse(
        json['distanceKm'].toString(),
      )
          : null,
      estimatedTravelTimeMinutes:
      json['estimatedTravelTimeMinutes'] is int
          ? json['estimatedTravelTimeMinutes']
          : int.tryParse(
        json['estimatedTravelTimeMinutes']
            ?.toString() ??
            '',
      ),
    );
  }
}

class TripRouteResponse {
  final String? tripActivityId;
  final String? destination;
  final double? totalDistanceKm;
  final int? estimatedTravelTimeMinutes;
  final String? encodedPolyline;
  final List<TripRouteStopResponse> stops;
  final List<TripRouteSegmentResponse> segments;

  TripRouteResponse({
    this.tripActivityId,
    this.destination,
    this.totalDistanceKm,
    this.estimatedTravelTimeMinutes,
    this.encodedPolyline,
    this.stops = const [],
    this.segments = const [],
  });

  factory TripRouteResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return TripRouteResponse(
      tripActivityId:
      json['tripActivityId']?.toString(),

      destination:
      json['destination']?.toString(),

      totalDistanceKm: json['totalDistanceKm'] != null
          ? double.tryParse(
        json['totalDistanceKm'].toString(),
      )
          : null,

      estimatedTravelTimeMinutes:
      json['estimatedTravelTimeMinutes'] is int
          ? json['estimatedTravelTimeMinutes']
          : int.tryParse(
        json['estimatedTravelTimeMinutes']
            ?.toString() ??
            '',
      ),

      encodedPolyline:
      json['encodedPolyline']?.toString(),

      stops: json['stops'] is List
          ? (json['stops'] as List)
          .map(
            (item) => TripRouteStopResponse.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : const [],

      segments: json['segments'] is List
          ? (json['segments'] as List)
          .map(
            (item) => TripRouteSegmentResponse.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : const [],
    );
  }
}