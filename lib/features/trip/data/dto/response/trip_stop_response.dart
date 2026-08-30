class TripStopResponse {
  final int? id;
  final String? locationName;
  final int? sequenceOrder;
  final DateTime? arrivalTime;
  final DateTime? departureTime;
  final String? locationAddress;
  final double? lat;
  final double? lng;
  final String? googlePlaceId;
  final bool? isCompleted;

  TripStopResponse({
    this.id,
    this.locationName,
    this.sequenceOrder,
    this.arrivalTime,
    this.departureTime,
    this.locationAddress,
    this.lat,
    this.lng,
    this.googlePlaceId,
    this.isCompleted,
  });

  factory TripStopResponse.fromJson(Map<String, dynamic> json) {
    return TripStopResponse(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      locationName: json['locationName']?.toString(),
      sequenceOrder: json['sequenceOrder'] is int
          ? json['sequenceOrder']
          : int.tryParse(json['sequenceOrder']?.toString() ?? ''),
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.tryParse(json['arrivalTime'].toString())
          : null,
      departureTime: json['departureTime'] != null
          ? DateTime.tryParse(json['departureTime'].toString())
          : null,
      locationAddress: json['locationAddress']?.toString(),
      lat: json['lat'] != null
          ? double.tryParse(json['lat'].toString())
          : null,
      lng: json['lng'] != null
          ? double.tryParse(json['lng'].toString())
          : null,
      googlePlaceId: json['googlePlaceId']?.toString(),
      isCompleted: json['isCompleted'],
    );
  }
}