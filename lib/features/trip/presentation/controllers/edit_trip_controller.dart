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
import '../../../groups/data/dto/response/pending_invite_response.dart';
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

  final RxList<PendingInviteResponse> pendingInvites =
      <PendingInviteResponse>[].obs;

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
        _loadPendingInvites(),
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

  Future<void> _loadPendingInvites() async {
    final result = await tripRepository.getPendingInvites(activityId);

    if (result is ApiSuccess<List<PendingInviteResponse>>) {
      pendingInvites.assignAll(result.data);
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

  Future<bool> addTripStop({
    required String locationName,
    required int sequenceOrder,
    DateTime? arrivalTime,
    DateTime? departureTime,
    String? locationAddress,
    double? lat,
    double? lng,
    String? googlePlaceId,
    String? coordinates,
  }) async {
    final value = locationName.trim();

    if (value.isEmpty) {
      return false;
    }

    final request = <String, dynamic>{
      'locationName': value,
      'sequenceOrder': sequenceOrder,
    };

    if (arrivalTime != null) {
      request['arrivalTime'] = arrivalTime.toIso8601String();
    }

    if (departureTime != null) {
      request['departureTime'] = departureTime.toIso8601String();
    }

    if (locationAddress != null) {
      request['locationAddress'] = locationAddress;
    }

    if (lat != null) {
      request['lat'] = lat;
    }

    if (lng != null) {
      request['lng'] = lng;
    }

    if (googlePlaceId != null) {
      request['googlePlaceId'] = googlePlaceId;
    }

    if (coordinates != null) {
      request['coordinates'] = coordinates;
    }

    final result = await tripRepository.addTripStop(
      activityId,
      request,
    );

    if (result is ApiSuccess<TripStopResponse>) {
      stops.add(result.data);
      return true;
    }

    if (result is ApiError<TripStopResponse>) {
      errorMessage.value = result.exception.message;
    }

    return false;
  }

  Future<bool> updateTripStop({
    required int stopId,
    required String locationName,
    DateTime? arrivalTime,
    DateTime? departureTime,
    String? locationAddress,
    double? lat,
    double? lng,
    String? googlePlaceId,
    String? coordinates,
    bool? isCompleted,
  }) async {
    final value = locationName.trim();

    if (value.isEmpty) {
      return false;
    }

    final index = stops.indexWhere(
          (stop) => stop.id == stopId,
    );

    if (index == -1) {
      return false;
    }

    final current = stops[index];

    final result = await tripRepository.updateTripStop(
      activityId,
      stopId,
      {
        'id': stopId,
        'locationName': value,
        'arrivalTime': arrivalTime?.toIso8601String(),
        'departureTime': departureTime?.toIso8601String(),
        'locationAddress': locationAddress,
        'lat': lat,
        'lng': lng,
        'googlePlaceId': googlePlaceId,
        'coordinates': coordinates,
        'isCompleted': isCompleted ?? current.isCompleted ?? false,
      },
    );

    if (result is ApiSuccess<TripStopResponse>) {
      stops[index] = result.data;
      return true;
    }

    if (result is ApiError<TripStopResponse>) {
      errorMessage.value = result.exception.message;
    }

    return false;
  }

  Future<bool> deleteTripStop(
      int stopId,
      ) async {
    final result = await tripRepository.deleteTripStop(
      activityId,
      stopId,
    );

    if (result is ApiSuccess<void>) {
      stops.removeWhere(
            (stop) => stop.id == stopId,
      );

      return true;
    }

    if (result is ApiError<void>) {
      errorMessage.value = result.exception.message;
    }

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

  Future<bool> deletePackingItem(
      int itemId,
      ) async {
    try {
      await tripRepository.deletePackingItem(
        activityId,
        itemId,
      );

      packingItems.removeWhere(
            (item) => item.id == itemId,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // checklist

  Future<bool> addChecklist(
      String itemName,
      ) async {
    final value = itemName.trim();

    if (value.isEmpty) {
      return false;
    }

    final result = await tripRepository.addChecklist(
      activityId,
      value,
    );

    if (result is ApiSuccess<void>) {
      await loadEditTripData();
      return true;
    }

    if (result is ApiError<void>) {
      errorMessage.value = result.exception.message;
    }

    return false;
  }

  Future<bool> toggleChecklist(
      int checklistId,
      ) async {
    final index = checklists.indexWhere(
          (item) => item.id == checklistId,
    );

    if (index == -1) {
      return false;
    }

    final current = checklists[index];

    final success = await updateTrip(
      updateChecklistItems: [
        {
          'id': checklistId,
          'itemName': current.itemName ?? '',
          'isCompleted': !current.completed,
        },
      ],
    );

    if (success) {
      checklists[index] = TripChecklistResponse(
        id: current.id,
        itemName: current.itemName,
        completed: !current.completed,
      );

      await tripController.getMyTrips();
    }

    return success;
  }

  Future<bool> deleteChecklist(int checklistId) async {
    final result = await tripRepository.deleteChecklist(
      activityId,
      checklistId,
    );

    if (result is ApiSuccess<void>) {
      checklists.removeWhere(
            (item) => item.id == checklistId,
      );
      return true;
    }

    if (result is ApiError<void>) {
      errorMessage.value = result.exception.message;
    }

    return false;
  }

  Future<bool> updateChecklist(
      int checklistId,
      String itemName,
      ) async {
    final request = {
      'itemName': itemName.trim(),
    };

    final result = await tripRepository.updateChecklist(
      activityId,
      checklistId,
      request,
    );

    if (result is ApiSuccess<void>) {
      final index = checklists.indexWhere(
            (item) => item.id == checklistId,
      );

      if (index != -1) {
        final current = checklists[index];

        checklists[index] = TripChecklistResponse(
          id: current.id,
          itemName: itemName.trim(),
          completed: current.completed,
        );

        checklists.refresh();
      }

      return true;
    }

    if (result is ApiError<void>) {
      errorMessage.value = result.exception.message;
    }

    return false;
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
