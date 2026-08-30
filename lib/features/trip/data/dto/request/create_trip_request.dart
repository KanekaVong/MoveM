class CreateTripRequest {
  final String activityName;
  final String? description;
  final String startActivity;
  final String? deadline;
  final String? locationName;
  final String? locationAddress;
  final double? lat;
  final double? lng;
  final String? googlePlaceId;
  final String? coordinates;
  final String? destination;
  final String? flightNumber;
  final String? hotelName;
  final String? parentActivityId;

  CreateTripRequest({
    required this.activityName,
    this.description,
    required this.startActivity,
    this.deadline,
    this.locationName,
    this.locationAddress,
    this.lat,
    this.lng,
    this.googlePlaceId,
    this.coordinates,
    this.destination,
    this.flightNumber,
    this.hotelName,
    this.parentActivityId,
  });

  Map<String, dynamic> toJson() {
    return {
      'activityName': activityName,
      'description': description,
      'startActivity': startActivity,
      'deadline': deadline,
      'locationName': locationName,
      'locationAddress': locationAddress,
      'lat': lat,
      'lng': lng,
      'googlePlaceId': googlePlaceId,
      'coordinates': coordinates,
      'destination': destination,
      'flightNumber': flightNumber,
      'hotelName': hotelName,
      'parentActivityId': parentActivityId,
    };
  }
}