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
              message: 'Invalid trip response from server.',
            ),
          );
        }
      }

      if (data is List) {
        final trips = data
            .map(
              (item) => TripSummaryResponse.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();

        return ApiSuccess(trips);
      }

      return ApiError(
        ApiException(
          message: 'Invalid trip response from server.',
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
          TripResponse.fromJson(data),
        );
      }

      return ApiError(
        ApiException(
          message: 'Invalid trip detail response from server.',
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
          message: 'Invalid create trip response from server.',
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
          message: 'Invalid reorder stops response from server.',
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
          message: 'Invalid packing items response from server.',
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
          message: 'Invalid packing item response from server.',
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
          message: 'Invalid packing item response from server.',
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
  Future<ApiResult<TripChecklistResponse>> addChecklist(
      String activityId,
      String itemName,
      ) async {
    try {
      final response = await tripService.addChecklist(
        activityId,
        itemName,
      );

      dynamic data = response.data;

      if (data is String) {
        data = jsonDecode(data);
      }

      if (data is Map<String, dynamic>) {
        final checklist =
        TripChecklistResponse.fromJson(data);

        return ApiSuccess(checklist);
      }

      return ApiError(
        ApiException(
          message:
          'Invalid add checklist response from server.',
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
          message: 'Invalid checklist response from server.',
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
  Future<ApiResult<void>> updateChecklist(
      int checklistId,
      String itemName,
      ) async {
    try {
      await tripService.updateChecklist(
        checklistId,
        itemName,
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
          message: 'Invalid attachment response from server.',
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
          message: 'Invalid attachment response from server.',
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
          message: 'Invalid members response from server.',
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
          message: 'Invalid update trip response from server.',
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

}