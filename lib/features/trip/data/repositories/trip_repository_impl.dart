import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/api_result.dart';

import '../../domain/repositories/trip_repository.dart';
import '../dto/response/trip_summary_response.dart';
import '../services/trip_service.dart';
import '../dto/request/create_trip_request.dart';
import '../dto/response/trip_response.dart';

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

}