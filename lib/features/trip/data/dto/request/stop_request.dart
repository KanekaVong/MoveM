class StopRequest {
  final String? locationName;
  final int sequenceOrder;
  final String? arrivalTime;
  final String? departureTime;
  final String? locationAddress;
  final double? lat;
  final double? lng;
  final String? googlePlaceId;
  final String? coordinates;

  StopRequest({
    this.locationName,
    required this.sequenceOrder,
    this.arrivalTime,
    this.departureTime,
    this.locationAddress,
    this.lat,
    this.lng,
    this.googlePlaceId,
    this.coordinates,
  });

  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'sequenceOrder': sequenceOrder,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
      'locationAddress': locationAddress,
      'lat': lat,
      'lng': lng,
      'googlePlaceId': googlePlaceId,
      'coordinates': coordinates,
    };
  }
}