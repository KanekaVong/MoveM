import 'trip_stop_response.dart';

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
  final String? flightNumber;
  final String? hotelName;

  final List<TripStopResponse> stops;

  final int? memberCount;
  final double? totalAllocatedBudget;
  final double? totalSpent;
  final double? perPersonShare;

  final List<dynamic> attachments;

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
    this.flightNumber,
    this.hotelName,
    this.stops = const [],
    this.memberCount,
    this.totalAllocatedBudget,
    this.totalSpent,
    this.perPersonShare,
    this.attachments = const [],
  });

  factory TripResponse.fromJson(Map<String, dynamic> json) {
    return TripResponse(
      activityId: json['activityId']?.toString() ?? '',
      activityName: json['activityName']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status']?.toString(),

      startActivity: json['startActivity'] != null
          ? DateTime.tryParse(json['startActivity'].toString())
          : null,

      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'].toString())
          : null,

      locationName: json['locationName']?.toString(),
      locationAddress: json['locationAddress']?.toString(),

      lat: json['lat'] != null
          ? double.tryParse(json['lat'].toString())
          : null,

      lng: json['lng'] != null
          ? double.tryParse(json['lng'].toString())
          : null,

      googlePlaceId: json['googlePlaceId']?.toString(),

      destination: json['destination']?.toString(),
      flightNumber: json['flightNumber']?.toString(),
      hotelName: json['hotelName']?.toString(),

      stops: json['stops'] is List
          ? (json['stops'] as List)
          .map(
            (item) => TripStopResponse.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],

      memberCount: json['memberCount'] is int
          ? json['memberCount']
          : int.tryParse(json['memberCount']?.toString() ?? ''),

      totalAllocatedBudget: json['totalAllocatedBudget'] != null
          ? double.tryParse(
        json['totalAllocatedBudget'].toString(),
      )
          : null,

      totalSpent: json['totalSpent'] != null
          ? double.tryParse(
        json['totalSpent'].toString(),
      )
          : null,

      perPersonShare: json['perPersonShare'] != null
          ? double.tryParse(
        json['perPersonShare'].toString(),
      )
          : null,

      attachments: json['attachments'] is List
          ? List<dynamic>.from(json['attachments'])
          : [],
    );
  }
}