import 'trip_stop_response.dart';
import 'trip_checklist_response.dart';
import 'trip_reminder_response.dart';
import 'trip_budget_response.dart';
import 'trip_packing_item_response.dart';
import 'trip_attachment_response.dart';

class TripResponse {
  final String activityId;
  final String activityName;
  final String? description;
  final String? status;

  final DateTime? startActivity;
  final DateTime? deadline;

  final String? locationName;
  final String? locationAddress;
  final double? lat;
  final double? lng;
  final String? googlePlaceId;

  final String? destination;

  final int? memberCount;
  final double? totalBudget;

  final List<TripStopResponse> stops;
  final List<TripChecklistResponse> checklists;
  final List<TripReminderResponse> reminders;
  final List<TripBudgetResponse> budgets;
  final List<TripPackingItemResponse> packingItems;
  final List<TripAttachmentResponse> attachments;

  TripResponse({
    required this.activityId,
    required this.activityName,
    this.description,
    this.status,
    this.startActivity,
    this.deadline,
    this.locationName,
    this.locationAddress,
    this.lat,
    this.lng,
    this.googlePlaceId,
    this.destination,
    this.memberCount,
    this.totalBudget,
    this.stops = const [],
    this.checklists = const [],
    this.reminders = const [],
    this.budgets = const [],
    this.packingItems = const [],
    this.attachments = const [],
  });

  factory TripResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return TripResponse(
      activityId: json['activityId']?.toString() ?? '',
      activityName: json['activityName']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      startActivity: json['startActivity'] != null
          ? DateTime.tryParse(
              json['startActivity'].toString(),
            )
          : null,
      deadline: json['deadline'] != null
          ? DateTime.tryParse(
              json['deadline'].toString(),
            )
          : null,
      locationName: json['locationName']?.toString(),
      locationAddress: json['locationAddress']?.toString(),
      lat: json['lat'] != null
          ? double.tryParse(
              json['lat'].toString(),
            )
          : null,
      lng: json['lng'] != null
          ? double.tryParse(
              json['lng'].toString(),
            )
          : null,
      googlePlaceId: json['googlePlaceId']?.toString(),
      destination: json['destination']?.toString(),
      memberCount: json['memberCount'] is int
          ? json['memberCount']
          : int.tryParse(
              json['memberCount']?.toString() ?? '',
            ),
      totalBudget: json['totalBudget'] != null
          ? double.tryParse(
              json['totalBudget'].toString(),
            )
          : null,
      stops: json['stops'] is List
          ? (json['stops'] as List)
              .map(
                (item) => TripStopResponse.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      checklists: json['checklists'] is List
          ? (json['checklists'] as List)
              .map(
                (item) => TripChecklistResponse.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      reminders: json['reminders'] is List
          ? (json['reminders'] as List)
              .map(
                (item) => TripReminderResponse.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      budgets: json['budgets'] is List
          ? (json['budgets'] as List)
              .map(
                (item) => TripBudgetResponse.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      packingItems: json['packingItems'] is List
          ? (json['packingItems'] as List)
              .map(
                (item) => TripPackingItemResponse.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      attachments: json['attachments'] is List
          ? (json['attachments'] as List)
              .map(
                (item) => TripAttachmentResponse.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
    );
  }
}
