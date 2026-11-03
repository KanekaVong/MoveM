import 'checklist_item_request.dart';
import 'packing_item_request.dart';
import 'stop_request.dart';

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

  final double totalBudget;

  final List<ChecklistItemRequest> checklistItems;
  final List<StopRequest> stops;
  final List<PackingItemRequest> packingItems;

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
    this.totalBudget = 0,
    this.checklistItems = const [],
    this.stops = const [],
    this.packingItems = const [],
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
      'totalBudget': totalBudget,

      'checklistItems': checklistItems
          .map((item) => item.toJson())
          .toList(),

      'stops': stops
          .map((stop) => stop.toJson())
          .toList(),

      'packingItems': packingItems
          .map((item) => item.toJson())
          .toList(),
    };
  }
}