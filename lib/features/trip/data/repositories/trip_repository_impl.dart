import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_result.dart';

import '../../domain/repositories/trip_repository.dart';
import '../dto/response/trip_summary_response.dart';
import '../services/trip_service.dart';
import '../dto/request/create_trip_request.dart';
import '../dto/response/trip_response.dart';
import '../dto/response/trip_stop_response.dart';
import '../dto/response/trip_packing_item_response.dart';
import '../dto/response/trip_checklist_response.dart';
import '../dto/response/trip_attachment_response.dart';
import '../dto/response/trip_member_response.dart';
import '../dto/request/update_trip_request.dart';
import '../dto/response/trip_route_response.dart';
import '../dto/response/trip_cover_photo_response.dart';
import '../../../groups/data/dto/response/pending_invite_response.dart';
import '../dto/request/trip_budget_request.dart';
import '../dto/response/trip_budget_response.dart';
import '../dto/request/trip_expense_request.dart';
import '../dto/response/trip_expense_response.dart';
import '../../data/dto/request/trip_expense_split_request.dart';
import 'package:movem/core/utils/l10n.dart';

class TripRepositoryImpl implements TripRepository {
  final TripService tripService;

  TripRepositoryImpl({
    required this.tripService,
  });

  @override
  Future<ApiResult<List<TripSummaryResponse>>> getMyTrips() async {
    try {
      final response = await tripService.getMyTrips();

      dynamic data = response.data;

      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {
          return ApiError(
            ApiException(
              message: tr.serverBadResponse,
            ),
          );
        }
      }

      if (data is List) {
        final items = await Future.wait(
          data.map(
            (item) => _withLiveStats(Map<String, dynamic>.from(item)),
          ),
        );
        final trips = items.map(TripSummaryResponse.fromJson).toList();

        return ApiSuccess(trips);
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }


  @override
  Future<ApiResult<TripResponse>> getTripDetail(
      String activityId,
      ) async {
    try {
      final response = await tripService.getTripDetail(activityId);

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripResponse.fromJson(
            await _withLiveStats(data, includeSpent: false),
          ),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  /// The trip list and detail payloads report `memberCount` and `totalSpent`
  /// as 0 even when the trip has members and logged expenses, so take them
  /// from `groups/{activityId}/members` and `trips/{activityId}/expenses`.
  /// The payload values are kept if either request fails.
  Future<Map<String, dynamic>> _withLiveStats(
    Map<String, dynamic> json, {
    bool includeSpent = true,
  }) async {
    final activityId = json['activityId']?.toString() ?? '';
    if (activityId.isEmpty) return json;

    final results = await Future.wait<ApiResult<dynamic>>([
      getTripMembers(activityId),
      if (includeSpent) getTripExpenses(activityId),
    ]);

    final members = results[0];
    if (members is ApiSuccess<List<TripMemberResponse>>) {
      json['memberCount'] = members.data.length;
    }

    if (includeSpent) {
      final expenses = results[1];
      if (expenses is ApiSuccess<List<TripExpenseResponse>>) {
        json['totalSpent'] = expenses.data.fold<double>(
          0,
          (sum, expense) => sum + (expense.amount ?? 0),
        );
      }
    }

    return json;
  }


  @override
  Future<ApiResult<TripRouteResponse>> getTripRoute(
      String activityId, {
        String travelMode = 'DRIVING',
      }) async {
    try {
      final response = await tripService.getTripRoute(
        activityId,
        travelMode: travelMode,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripRouteResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }


  @override
  Future<ApiResult<TripResponse>> createTrip(
      CreateTripRequest request,
      ) async {
    try {
      final response = await tripService.createTrip(request);

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteTrip(String activityId) async {
    try {
      await tripService.deleteTrip(activityId);

      return const ApiSuccess(null);
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<List<TripStopResponse>>> reorderStops(
      String activityId,
      List<int> stopIds,
      ) async {
    try {
      final response = await tripService.reorderStops(
        activityId,
        stopIds,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is List) {
        final stops = data
            .map(
              (item) => TripStopResponse.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();

        return ApiSuccess(stops);
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripStopResponse>> addTripStop(
      String activityId,
      Map<String, dynamic> request,
      ) async {
    try {
      final response = await tripService.addTripStop(
        activityId,
        request,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripStopResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripStopResponse>> updateTripStop(
      String activityId,
      int stopId,
      Map<String, dynamic> request,
      ) async {
    try {
      final response = await tripService.updateTripStop(
        activityId,
        stopId,
        request,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripStopResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteTripStop(
      String activityId,
      int stopId,
      ) async {
    try {
      await tripService.deleteTripStop(
        activityId,
        stopId,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<List<TripPackingItemResponse>>> getPackingItems(
      String activityId,
      ) async {
    try {
      final response = await tripService.getPackingItems(
        activityId,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is List) {
        final items = data
            .map(
              (item) => TripPackingItemResponse.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();

        return ApiSuccess(items);
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripPackingItemResponse>> addPackingItem(
      String activityId,
      String itemName,
      ) async {
    try {
      final response = await tripService.addPackingItem(
        activityId,
        itemName,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripPackingItemResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripPackingItemResponse>> togglePackingItem(
      String activityId,
      int itemId,
      ) async {
    try {
      final response = await tripService.togglePackingItem(
        activityId,
        itemId,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripPackingItemResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> deletePackingItem(
      String activityId,
      int itemId,
      ) async {
    await tripService.deletePackingItem(
      activityId,
      itemId,
    );
  }

  @override
  Future<ApiResult<void>> addChecklist(
      String activityId,
      String itemName,
      ) async {
    try {
      await tripService.addChecklist(
        activityId,
        itemName,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<List<TripChecklistResponse>>> getChecklists(
      String activityId,
      ) async {
    try {
      final response = await tripService.getChecklists(
        activityId,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is List) {
        final items = data
            .map(
              (item) => TripChecklistResponse.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();

        return ApiSuccess(items);
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> completeChecklist(
      int checklistId,
      ) async {
    try {
      await tripService.completeChecklist(
        checklistId,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteChecklist(
      String activityId,
      int checklistId,
      ) async {
    try {
      await tripService.deleteChecklist(
        activityId,
        checklistId,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> updateChecklist(
      String activityId,
      int checklistId,
      Map<String, dynamic> request,
      ) async {
    try {
      await tripService.updateChecklist(
        activityId,
        checklistId,
        request,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<List<TripAttachmentResponse>>> getAttachments(
      String activityId,
      ) async {
    try {
      final response = await tripService.getAttachments(
        activityId,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is List) {
        final attachments = data
            .map(
              (item) => TripAttachmentResponse.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();

        return ApiSuccess(attachments);
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripAttachmentResponse>> uploadAttachment(
      String activityId,
      MultipartFile file,
      ) async {
    try {
      final response = await tripService.uploadAttachment(
        activityId,
        file,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripAttachmentResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripCoverPhotoResponse>> getCoverPhoto(
      String activityId,
      ) async {
    try {
      final response = await tripService.getCoverPhoto(
        activityId,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripCoverPhotoResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message:
          tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripCoverPhotoResponse>> uploadCoverPhoto(
      String activityId,
      MultipartFile file,
      ) async {
    try {
      final response = await tripService.uploadCoverPhoto(
        activityId,
        file,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripCoverPhotoResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message:
          tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<List<TripMemberResponse>>> getTripMembers(
      String activityId,
      ) async {
    try {
      final response = await tripService.getTripMembers(
        activityId,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is List) {
        final members = data
            .map(
              (item) => TripMemberResponse.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();

        return ApiSuccess(members);
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> inviteTripMember(
      String activityId,
      String identifier,
      ) async {
    try {
      await tripService.inviteTripMember(
        activityId,
        identifier,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> removeTripMember(
      String activityId,
      int memberId,
      ) async {
    try {
      await tripService.removeTripMember(
        activityId,
        memberId,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<List<PendingInviteResponse>>> getPendingInvites(
      String activityId,
      ) async {
    try {
      final response = await tripService.getPendingInvites(activityId);

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is List) {
        final invites = data
            .map(
              (item) => PendingInviteResponse.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();

        return ApiSuccess(invites);
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<TripResponse>> updateTrip(
      String activityId,
      UpdateTripRequest request,
      ) async {
    try {
      final response = await tripService.updateTrip(
        activityId,
        request,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripBudgetResponse>> updateTripBudget(
      String activityId,
      int budgetId,
      TripBudgetRequest request,
      ) async {
    try {
      final response = await tripService.updateTripBudget(
        activityId,
        budgetId,
        request,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripBudgetResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<TripExpenseResponse>> createTripExpense(
      String activityId,
      TripExpenseRequest request,
      ) async {
    try {
      final response = await tripService.createTripExpense(
        activityId,
        request,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripExpenseResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<List<TripExpenseResponse>>> getTripExpenses(
      String activityId,
      ) async {
    try {
      final response = await tripService.getTripExpenses(activityId);

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is List) {
        return ApiSuccess(
          data
              .map(
                (e) => TripExpenseResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
              .toList(),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<void>> deleteTripExpense(
      String activityId,
      int expenseId,
      ) async {
    try {
      await tripService.deleteTripExpense(
        activityId,
        expenseId,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(ApiException.fromDioError(e));
    } catch (e) {
      return ApiError(
        ApiException(message: e.toString()),
      );
    }
  }

  @override
  Future<ApiResult<TripExpenseResponse>> createExpenseSplits(
      String activityId,
      String tripActivityId,
      int expenseId,
      TripExpenseSplitRequest request,
      ) async {
    try {
      final response = await tripService.createExpenseSplits(
        activityId,
        tripActivityId,
        expenseId,
        request,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        return ApiSuccess(
          TripExpenseResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: tr.serverBadResponse,
        ),
      );
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<ApiResult<void>> settleExpenseSplit(
      String activityId,
      int expenseId,
      int splitId,
      ) async {
    try {
      await tripService.settleExpenseSplit(
        activityId,
        expenseId,
        splitId,
      );

      return const ApiSuccess(null);
    } on DioException catch (e) {
      return ApiError(
        ApiException.fromDioError(e),
      );
    } catch (e) {
      return ApiError(
        ApiException(
          message: e.toString(),
        ),
      );
    }
  }

}