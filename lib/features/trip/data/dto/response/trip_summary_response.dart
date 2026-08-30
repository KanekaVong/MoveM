class TripSummaryResponse {
  final String activityId;
  final String activityName;
  final String? destination;
  final String? locationName;
  final DateTime? startActivity;
  final DateTime? deadline;
  final String? status;
  final int? memberCount;
  final double? totalAllocatedBudget;
  final double? totalSpent;

  TripSummaryResponse({
    required this.activityId,
    required this.activityName,
    this.destination,
    this.locationName,
    this.startActivity,
    this.deadline,
    this.status,
    this.memberCount,
    this.totalAllocatedBudget,
    this.totalSpent,
  });

  factory TripSummaryResponse.fromJson(Map<String, dynamic> json) {
    return TripSummaryResponse(
      activityId: json['activityId']?.toString() ?? '',
      activityName: json['activityName']?.toString() ?? '',
      destination: json['destination']?.toString(),
      locationName: json['locationName']?.toString(),
      startActivity: json['startActivity'] != null
          ? DateTime.tryParse(json['startActivity'].toString())
          : null,
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'].toString())
          : null,
      status: json['status']?.toString(),
      memberCount: json['memberCount'] is int
          ? json['memberCount']
          : int.tryParse(json['memberCount']?.toString() ?? ''),
      totalAllocatedBudget: json['totalAllocatedBudget'] != null
          ? double.tryParse(json['totalAllocatedBudget'].toString())
          : null,
      totalSpent: json['totalSpent'] != null
          ? double.tryParse(json['totalSpent'].toString())
          : null,
    );
  }
}