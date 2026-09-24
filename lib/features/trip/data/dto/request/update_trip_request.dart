class UpdateTripRequest {
  final String? activityName;
  final String? description;
  final DateTime? startActivity;
  final DateTime? deadline;
  final String? locationName;
  final String? locationAddress;
  final double? lat;
  final double? lng;
  final String? googlePlaceId;
  final String? coordinates;
  final String? destination;
  final String? status;
  final double? totalBudget;
  final List<Map<String, dynamic>>? addChecklistItems;
  final List<Map<String, dynamic>>? updateChecklistItems;

  UpdateTripRequest({
    this.activityName,
    this.description,
    this.startActivity,
    this.deadline,
    this.locationName,
    this.locationAddress,
    this.lat,
    this.lng,
    this.googlePlaceId,
    this.coordinates,
    this.destination,
    this.status,
    this.totalBudget,
    this.addChecklistItems,
    this.updateChecklistItems,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'activityName': activityName,
      'description': description,
      'startActivity': startActivity?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'locationName': locationName,
      'locationAddress': locationAddress,
      'lat': lat,
      'lng': lng,
      'googlePlaceId': googlePlaceId,
      'coordinates': coordinates,
      'destination': destination,
      'status': status,
    };

    if (totalBudget != null) {
      json['totalBudget'] = totalBudget;
    }

    if (addChecklistItems != null) {
      json['addChecklistItems'] = addChecklistItems;
    }

    if (updateChecklistItems != null) {
      json['updateChecklistItems'] = updateChecklistItems;
    }

    return json;
  }
}