import 'package:get/get.dart';
import '../../../../core/network/api_result.dart';
import '../../data/dto/response/trip_response.dart';

import '../../../../shared/base/base_controller.dart';
import '../models/create_trip_draft.dart';
import '../models/create_trip_stop_draft.dart';
import '../../domain/repositories/trip_repository.dart';
import 'package:movem/features/friends/data/dto/response/friend_response.dart';
import '../../data/dto/request/create_trip_request.dart';
import '../../data/dto/request/checklist_item_request.dart';
import '../../data/dto/request/packing_item_request.dart';
import '../../data/dto/request/stop_request.dart';
import 'package:flutter/foundation.dart';


class CreateTripController extends BaseController {
  final TripRepository tripRepository;

  CreateTripController({
    required this.tripRepository,
  });

  final Rx<CreateTripDraft> draft =
      CreateTripDraft().obs;

  final RxBool isSubmitting = false.obs;

  void setActivityName(String value) {
    draft.value.activityName = value;
    draft.refresh();
  }

  void setDestination({
    String? locationName,
    String? locationAddress,
    double? lat,
    double? lng,
    String? googlePlaceId,
  }) {
    draft.value.locationName = locationName;
    draft.value.locationAddress = locationAddress;
    draft.value.lat = lat;
    draft.value.lng = lng;
    draft.value.googlePlaceId = googlePlaceId;
    draft.value.destination = locationName;

    draft.refresh();
  }

  void setDates({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    draft.value.startDate = startDate;
    draft.value.endDate = endDate;

    draft.value.durationDays =
        DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
        ).difference(
          DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
          ),
        ).inDays +
            1;

    draft.refresh();
  }

  void setBudget(double value) {
    draft.value.budget = value;
    draft.refresh();
  }

  void increaseDuration() {
    final current = draft.value;

    if (current.startDate == null) return;

    current.durationDays++;

    final currentEnd = current.endDate;

    final timeHour = currentEnd?.hour ??
        current.startDate!.hour;

    final timeMinute = currentEnd?.minute ??
        current.startDate!.minute;

    current.endDate = DateTime(
      current.startDate!.year,
      current.startDate!.month,
      current.startDate!.day,
    ).add(
      Duration(
        days: current.durationDays - 1,
      ),
    );

    current.endDate = DateTime(
      current.endDate!.year,
      current.endDate!.month,
      current.endDate!.day,
      timeHour,
      timeMinute,
    );

    draft.refresh();
  }

  void decreaseDuration() {
    final current = draft.value;

    if (current.durationDays <= 1) return;
    if (current.startDate == null) return;

    current.durationDays--;

    final currentEnd = current.endDate;

    final timeHour = currentEnd?.hour ??
        current.startDate!.hour;

    final timeMinute = currentEnd?.minute ??
        current.startDate!.minute;

    final newEndDate =
    DateTime(
      current.startDate!.year,
      current.startDate!.month,
      current.startDate!.day,
    ).add(
      Duration(
        days: current.durationDays - 1,
      ),
    );

    current.endDate = DateTime(
      newEndDate.year,
      newEndDate.month,
      newEndDate.day,
      timeHour,
      timeMinute,
    );

    draft.refresh();
  }


  void addStop(
      CreateTripStopDraft stop, {
        int? insertionIndex,
      }) {
    if (insertionIndex == null ||
        insertionIndex < 0 ||
        insertionIndex > draft.value.stops.length) {
      draft.value.stops.add(stop);
    } else {
      draft.value.stops.insert(
        insertionIndex,
        stop,
      );
    }

    draft.refresh();
  }

  void updateStop(
      int index,
      CreateTripStopDraft stop,
      ) {
    if (index < 0 ||
        index >= draft.value.stops.length) {
      return;
    }

    draft.value.stops[index] = stop;
    draft.refresh();
  }

  void removeStop(int index) {
    if (index < 0 ||
        index >= draft.value.stops.length) {
      return;
    }

    draft.value.stops.removeAt(index);
    draft.refresh();
  }


  void addFriend(FriendResponse friend) {
    final exists = draft.value.friends.any(
          (item) => item.userId == friend.userId,
    );

    if (exists) return;

    draft.value.friends.add(friend);
    draft.refresh();
  }

  void removeFriend(FriendResponse friend) {
    draft.value.friends.removeWhere(
          (item) => item.userId == friend.userId,
    );

    draft.refresh();
  }

  void toggleFriend(FriendResponse friend) {
    final exists = draft.value.friends.any(
          (item) => item.userId == friend.userId,
    );

    if (exists) {
      removeFriend(friend);
    } else {
      addFriend(friend);
    }
  }

  void addPackingItem(String item) {
    final value = item.trim();

    if (value.isEmpty) return;

    draft.value.packingItems.add(value);
    draft.refresh();
  }

  void removePackingItem(int index) {
    if (index < 0 ||
        index >= draft.value.packingItems.length) {
      return;
    }

    draft.value.packingItems.removeAt(index);
    draft.refresh();
  }

  void addChecklistItem(String item) {
    final value = item.trim();

    if (value.isEmpty) return;

    draft.value.checklistItems.add(value);
    draft.refresh();
  }

  void removeChecklistItem(int index) {
    if (index < 0 ||
        index >= draft.value.checklistItems.length) {
      return;
    }

    draft.value.checklistItems.removeAt(index);
    draft.refresh();
  }


  // RESET
  void resetDraft() {
    draft.value = CreateTripDraft();
    draft.refresh();
  }

  CreateTripDraft get currentDraft => draft.value;

  Future<bool> submitTrip() async {
    final current = currentDraft;

    if (current.activityName == null ||
        current.activityName!.trim().isEmpty) {
      errorMessage.value = 'Trip name is required.';
      return false;
    }

    if (current.startDate == null) {
      errorMessage.value = 'Start date is required.';
      return false;
    }

    isSubmitting.value = true;

    try {
      final request = CreateTripRequest(
        activityName: current.activityName!.trim(),

        startActivity: current.startDate!.toIso8601String(),

        deadline: current.endDate?.toIso8601String(),

        locationName: current.locationName,
        locationAddress: current.locationAddress,

        lat: current.lat,
        lng: current.lng,

        googlePlaceId: current.googlePlaceId,
        destination: current.destination,

        totalBudget: current.budget,

        checklistItems: current.checklistItems
            .map(
              (item) => ChecklistItemRequest(
            itemName: item,
          ),
        )
            .toList(),

        packingItems: current.packingItems
            .map(
              (item) => PackingItemRequest(
            itemName: item,
          ),
        )
            .toList(),

        stops: current.stops
            .asMap()
            .entries
            .map(
              (entry) {
            final index = entry.key;
            final stop = entry.value;

            return StopRequest(
              locationName: stop.locationName,
              sequenceOrder: index + 1,
              locationAddress: stop.locationAddress,
              lat: stop.lat,
              lng: stop.lng,
              googlePlaceId: stop.googlePlaceId,
            );
          },
        )
            .toList(),
      );

      final result = await tripRepository.createTrip(request);

      if (result is ApiSuccess<TripResponse>) {
        return true;
      }

      if (result is ApiError<TripResponse>) {
        errorMessage.value = result.exception.message;
        return false;
      }

      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

}