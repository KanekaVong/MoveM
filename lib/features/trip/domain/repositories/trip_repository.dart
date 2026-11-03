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
import '../../data/dto/response/trip_route_response.dart';
import '../../data/dto/response/trip_cover_photo_response.dart';
import '../../../groups/data/dto/response/pending_invite_response.dart';
import '../../data/dto/request/trip_budget_request.dart';
import '../../data/dto/response/trip_budget_response.dart';
import '../../data/dto/response/trip_expense_response.dart';
import '../../data/dto/request/trip_expense_request.dart';
import '../../data/dto/request/trip_expense_split_request.dart';
import 'package:dio/dio.dart';

abstract class TripRepository {

  Future<ApiResult<List<TripSummaryResponse>>> getMyTrips();

  Future<ApiResult<TripResponse>> getTripDetail(String activityId);

  Future<ApiResult<TripRouteResponse>> getTripRoute(
      String activityId, {
        String travelMode = 'DRIVING',
      });

  Future<ApiResult<TripResponse>> createTrip(
      CreateTripRequest request,
      );

  Future<ApiResult<void>> deleteTrip(String activityId);

  Future<ApiResult<List<TripStopResponse>>> reorderStops(
      String activityId,
      List<int> stopIds,
      );

  Future<ApiResult<TripStopResponse>> addTripStop(
      String activityId,
      Map<String, dynamic> request,
      );

  Future<ApiResult<TripStopResponse>> updateTripStop(
      String activityId,
      int stopId,
      Map<String, dynamic> request,
      );

  Future<ApiResult<void>> deleteTripStop(
      String activityId,
      int stopId,
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

  Future<void> deletePackingItem(
      String activityId,
      int itemId,
      );

  Future<ApiResult<void>> addChecklist(
      String activityId,
      String itemName,
      );

  Future<ApiResult<List<TripChecklistResponse>>> getChecklists(
      String activityId,
      );

  Future<ApiResult<void>> completeChecklist(
      int checklistId,
      );

  Future<ApiResult<void>> deleteChecklist(
      String activityId,
      int checklistId,
      );

  Future<ApiResult<void>> updateChecklist(
      String activityId,
      int checklistId,
      Map<String, dynamic> request,
      );

  Future<ApiResult<List<TripAttachmentResponse>>> getAttachments(
      String activityId,
      );

  Future<ApiResult<TripAttachmentResponse>> uploadAttachment(
      String activityId,
      MultipartFile file,
      );

  Future<ApiResult<TripCoverPhotoResponse>> getCoverPhoto(
      String activityId,
      );

  Future<ApiResult<TripCoverPhotoResponse>> uploadCoverPhoto(
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

  Future<ApiResult<List<PendingInviteResponse>>> getPendingInvites(
      String activityId,
      );

  Future<ApiResult<TripResponse>> updateTrip(
      String activityId,
      UpdateTripRequest request,
      );

  Future<ApiResult<TripBudgetResponse>> updateTripBudget(
      String activityId,
      int budgetId,
      TripBudgetRequest request,
      );

  Future<ApiResult<TripExpenseResponse>> createTripExpense(
      String activityId,
      TripExpenseRequest request,
      );

  Future<ApiResult<List<TripExpenseResponse>>> getTripExpenses(
      String activityId,
      );

  Future<ApiResult<void>> deleteTripExpense(
      String activityId,
      int expenseId,
      );

  Future<ApiResult<TripExpenseResponse>> createExpenseSplits(
      String activityId,
      String tripActivityId,
      int expenseId,
      TripExpenseSplitRequest request,
      );

  Future<ApiResult<void>> settleExpenseSplit(
      String activityId,
      int expenseId,
      int splitId,
      );

}