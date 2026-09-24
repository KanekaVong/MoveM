import '../../../../core/network/api_result.dart';
import '../../data/dto/request/create_trip_request.dart';
import '../../data/dto/response/trip_summary_response.dart';
import '../../data/dto/response/trip_response.dart';
import '../../data/dto/response/trip_member_response.dart';
import '../../data/dto/response/trip_packing_item_response.dart';
import '../../data/dto/response/trip_attachment_response.dart';
import '../../data/dto/response/trip_stop_response.dart';
import '../../data/dto/response/trip_checklist_response.dart';
import '../../data/dto/request/update_trip_request.dart';
import 'package:dio/dio.dart';

abstract class TripRepository {

  Future<ApiResult<List<TripSummaryResponse>>> getMyTrips();

  Future<ApiResult<TripResponse>> getTripDetail(String activityId);

  Future<ApiResult<TripResponse>> createTrip(
      CreateTripRequest request,
      );

  Future<ApiResult<void>> deleteTrip(String activityId);

  Future<ApiResult<List<TripStopResponse>>> reorderStops(
      String activityId,
      List<int> stopIds,
      );

  Future<ApiResult<List<TripPackingItemResponse>>> getPackingItems(
      String activityId,
      );

  Future<ApiResult<TripPackingItemResponse>> addPackingItem(
      String activityId,
      String itemName,
      );

  Future<ApiResult<TripPackingItemResponse>> togglePackingItem(
      String activityId,
      int itemId,
      );

  Future<ApiResult<TripChecklistResponse>> addChecklist(
      String activityId,
      String itemName,
      );

  Future<ApiResult<List<TripChecklistResponse>>> getChecklists(
      String activityId,
      );

  Future<ApiResult<void>> completeChecklist(
      int checklistId,
      );

  Future<ApiResult<void>> updateChecklist(
      int checklistId,
      String itemName,
      );

  Future<ApiResult<List<TripAttachmentResponse>>> getAttachments(
      String activityId,
      );

  Future<ApiResult<TripAttachmentResponse>> uploadAttachment(
      String activityId,
      MultipartFile file,
      );

  Future<ApiResult<List<TripMemberResponse>>> getTripMembers(
      String activityId,
      );

  Future<ApiResult<void>> inviteTripMember(
      String activityId,
      String identifier,
      );

  Future<ApiResult<void>> removeTripMember(
      String activityId,
      int memberId,
      );

  Future<ApiResult<TripResponse>> updateTrip(
      String activityId,
      UpdateTripRequest request,
      );

}