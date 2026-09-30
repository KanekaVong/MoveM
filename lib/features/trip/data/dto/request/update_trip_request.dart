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
    final json = <String, dynamic>{};

    if (activityName != null) {
      json['activityName'] = activityName;
    }

    if (startActivity != null) {
      json['startActivity'] =
          startActivity!.toIso8601String();
    }

    if (deadline != null) {
      json['deadline'] =
          deadline!.toIso8601String();
    }

    if (destination != null) {
      json['destination'] = destination;
    }

    if (totalBudget != null) {
      json['totalBudget'] = totalBudget;
    }

    if (description != null) {
      json['description'] = description;
    }

    if (locationName != null) {
      json['locationName'] = locationName;
    }

    if (locationAddress != null) {
      json['locationAddress'] = locationAddress;
    }

    if (lat != null) {
      json['lat'] = lat;
    }

    if (lng != null) {
      json['lng'] = lng;
    }

    if (googlePlaceId != null) {
      json['googlePlaceId'] = googlePlaceId;
    }

    if (coordinates != null) {
      json['coordinates'] = coordinates;
    }

    if (status != null) {
      json['status'] = status;
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