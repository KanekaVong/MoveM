import 'create_trip_stop_draft.dart';
import 'package:movem/features/friends/data/dto/response/friend_response.dart';

class CreateTripDraft {
  String? activityName;

  String? destination;
  String? locationName;
  String? locationAddress;
  double? lat;
  double? lng;
  String? googlePlaceId;

  DateTime? startDate;
  DateTime? endDate;
  int durationDays = 1;

  double budget = 0;

  List<CreateTripStopDraft> stops = [];

  List<FriendResponse> friends = [];
  List<String> packingItems = [];
  List<String> checklistItems = [];

}