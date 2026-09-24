import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/dto/response/trip_attachment_response.dart';
import '../../data/dto/response/trip_checklist_response.dart';
import '../../data/dto/response/trip_member_response.dart';
import '../../data/dto/response/trip_packing_item_response.dart';
import '../../data/dto/response/trip_response.dart';
import '../../data/dto/response/trip_stop_response.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../../../core/network/api_result.dart';
import '../../data/dto/request/update_trip_request.dart';
import 'trip_controller.dart';
import 'package:flutter/material.dart';

class EditTripController extends BaseController {
  final TripRepository tripRepository;
  final TripController tripController;
  final String activityId;

  EditTripController({
    required this.tripRepository,
    required this.tripController,
    required this.activityId,
  });

  // Reactive State
  final Rx<TripResponse?> trip = Rx<TripResponse?>(null);

  final RxList<TripMemberResponse> members = <TripMemberResponse>[].obs;

  final RxList<TripStopResponse> stops = <TripStopResponse>[].obs;

  final RxList<TripPackingItemResponse> packingItems =
      <TripPackingItemResponse>[].obs;

  final RxList<TripChecklistResponse> checklists =
      <TripChecklistResponse>[].obs;

  final RxList<TripAttachmentResponse> attachments =
      <TripAttachmentResponse>[].obs;

  final RxBool isEditLoading = false.obs;
  final RxBool isSaving = false.obs;

  final RxBool isEditing = false.obs;
  final RxString selectedEditSection = 'tripName'.obs;

  void startEditing() {
    isEditing.value = true;
    selectedEditSection.value = 'tripName';
  }

  void stopEditing() {
    isEditing.value = false;
  }

  void selectEditSection(String section) {
    selectedEditSection.value = section;
  }

  Future<void> loadEditTripData() async {
    isEditLoading.value = true;

    try {
      await Future.wait([
        _loadTrip(),
        _loadMembers(),
        _loadPackingItems(),
        _loadChecklists(),
        _loadAttachments(),
      ]);
    } finally {
      isEditLoading.value = false;
    }
  }

  void toggleEditing() {
    if (isEditing.value) {
      stopEditing();
    } else {
      startEditing();
    }
  }

  Future<void> _loadTrip() async {
    final result = await tripRepository.getTripDetail(activityId);

    if (result is ApiSuccess<TripResponse>) {
      trip.value = result.data;

      stops.assignAll(result.data.stops);
      checklists.assignAll(result.data.checklists);
    } else if (result is ApiError<TripResponse>) {
      errorMessage.value = result.exception.message;
    }
  }

  Future<void> _loadMembers() async {
    final result = await tripRepository.getTripMembers(activityId);

    if (result is ApiSuccess<List<TripMemberResponse>>) {
      members.assignAll(result.data);
    }
  }

  Future<void> _loadPackingItems() async {
    final result = await tripRepository.getPackingItems(activityId);

    if (result is ApiSuccess<List<TripPackingItemResponse>>) {
      packingItems.assignAll(result.data);
    }
  }

  Future<void> _loadChecklists() async {
    final result = await tripRepository.getChecklists(activityId);

    if (result is ApiSuccess<List<TripChecklistResponse>>) {
      checklists.assignAll(result.data);
    }
  }

  Future<void> _loadAttachments() async {
    final result = await tripRepository.getAttachments(
      activityId,
    );

    if (result is ApiSuccess<List<TripAttachmentResponse>>) {
      attachments.assignAll(result.data);
    }

    if (result is ApiError<List<TripAttachmentResponse>>) {
      errorMessage.value = result.exception.message;
    }
  }

  // trip
  Future<bool> updateTrip({
    String? activityName,
    DateTime? startActivity,
    DateTime? deadline,
    List<Map<String, dynamic>>? addChecklistItems,
    List<Map<String, dynamic>>? updateChecklistItems,
  }) async {
    debugPrint('EDIT CONTROLLER: updateTrip() called');
    debugPrint('EDIT CONTROLLER: activityName = $activityName');
    final currentTrip = trip.value;

    if (currentTrip == null) {
      debugPrint('EDIT CONTROLLER: trip is NULL');
      return false;
    }

    isSaving.value = true;

    try {
      final request = UpdateTripRequest(
        activityName: activityName ?? currentTrip.activityName,
        description: currentTrip.description,
        startActivity: startActivity ?? currentTrip.startActivity,
        deadline: deadline ?? currentTrip.deadline,
        locationName: currentTrip.locationName,
        locationAddress: currentTrip.locationAddress,
        lat: currentTrip.lat,
        lng: currentTrip.lng,
        googlePlaceId: currentTrip.googlePlaceId,
        destination: currentTrip.destination,
        status: currentTrip.status,
        addChecklistItems: addChecklistItems,
        updateChecklistItems: updateChecklistItems,
      );

      debugPrint('EDIT CONTROLLER: sending PUT');
      debugPrint('EDIT CONTROLLER: activityId = $activityId');
      debugPrint('EDIT CONTROLLER: request = ${request.toJson()}');

      final result = await tripRepository.updateTrip(
        activityId,
        request,
      );

      debugPrint(
        'EDIT CONTROLLER: result type = ${result.runtimeType}',
      );

      if (result is ApiSuccess<TripResponse>) {
        trip.value = result.data;

        stops.assignAll(
          result.data.stops,
        );

        checklists.assignAll(
          result.data.checklists,
        );

        return true;
      }

      if (result is ApiError<TripResponse>) {
        errorMessage.value = result.exception.message;
      }

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> saveTripName(String name) async {
    final value = name.trim();

    if (value.isEmpty) {
      return false;
    }

    final success = await updateTrip(
      activityName: value,
    );

    if (success) {
      await tripController.getMyTrips();
      stopEditing();
    }

    return success;
  }

  Future<bool> saveDuration({
    required DateTime startActivity,
    required DateTime deadline,
  }) async {
    if (deadline.isBefore(startActivity)) {
      return false;
    }

    final success = await updateTrip(
      startActivity: startActivity,
      deadline: deadline,
    );

    if (success) {
      await tripController.getMyTrips();
      stopEditing();
    }

    return success;
  }

  // stops
  Future<bool> reorderStops(
    int oldIndex,
    int newIndex,
  ) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final stop = stops.removeAt(oldIndex);

    stops.insert(
      newIndex,
      stop,
    );

    final stopIds = stops.map((stop) => stop.id).whereType<int>().toList();

    final result = await tripRepository.reorderStops(
      activityId,
      stopIds,
    );

    if (result is ApiSuccess<List<TripStopResponse>>) {
      stops.assignAll(result.data);
      return true;
    }

    // Reload original server order if failed.
    await _loadTrip();

    return false;
  }

  // packing items
  Future<bool> addPackingItem(
    String itemName,
  ) async {
    final value = itemName.trim();

    if (value.isEmpty) {
      return false;
    }

    final result = await tripRepository.addPackingItem(
      activityId,
      value,
    );

    if (result is ApiSuccess<TripPackingItemResponse>) {
      packingItems.add(result.data);
      return true;
    }

    return false;
  }

  Future<bool> togglePackingItem(
    int itemId,
  ) async {
    final result = await tripRepository.togglePackingItem(
      activityId,
      itemId,
    );

    if (result is ApiSuccess<TripPackingItemResponse>) {
      final index = packingItems.indexWhere(
        (item) => item.id == itemId,
      );

      if (index != -1) {
        packingItems[index] = result.data;
      }

      return true;
    }

    return false;
  }

  // checklist

  Future<bool> addChecklist(
      String itemName,
      ) async {
    final value = itemName.trim();

    if (value.isEmpty) {
      return false;
    }

    final success = await updateTrip(
      addChecklistItems: [
        {
          'itemName': value,
        },
      ],
    );

    if (success) {
      await tripController.getMyTrips();
    }

    return success;
  }

  Future<bool> toggleChecklist(
    int checklistId,
  ) async {
    final result = await tripRepository.completeChecklist(
      checklistId,
    );

    if (result is ApiSuccess<void>) {
      final index = checklists.indexWhere(
        (item) => item.id == checklistId,
      );

      if (index != -1) {
        final current = checklists[index];

        checklists[index] = TripChecklistResponse(
          id: current.id,
          itemName: current.itemName,
          completed: !current.completed,
        );
      }

      return true;
    }

    return false;
  }

  Future<bool> updateChecklist(
      int checklistId,
      String itemName,
      ) async {
    final value = itemName.trim();

    if (value.isEmpty) {
      return false;
    }

    final success = await updateTrip(
      updateChecklistItems: [
        {
          'id': checklistId,
          'itemName': value,
        },
      ],
    );

    if (success) {
      await tripController.getMyTrips();
    }

    return success;
  }

  // attachment

  Future<bool> uploadAttachment(
      dio.MultipartFile file,
      ) async {
    final result = await tripRepository.uploadAttachment(
      activityId,
      file,
    );

    if (result is ApiSuccess<TripAttachmentResponse>) {
      attachments.add(result.data);
      return true;
    }

    if (result is ApiError<TripAttachmentResponse>) {
      errorMessage.value = result.exception.message;
    }

    return false;
  }

  // members

  Future<bool> inviteMember(
    String identifier,
  ) async {
    final value = identifier.trim();

    if (value.isEmpty) {
      return false;
    }

    final result = await tripRepository.inviteTripMember(
      activityId,
      value,
    );

    if (result is ApiSuccess<void>) {
      return true;
    }

    return false;
  }

  Future<bool> removeMember(
    int memberId,
  ) async {
    final result = await tripRepository.removeTripMember(
      activityId,
      memberId,
    );

    if (result is ApiSuccess<void>) {
      members.removeWhere(
        (member) => member.userId == memberId,
      );

      return true;
    }

    return false;
  }
}
