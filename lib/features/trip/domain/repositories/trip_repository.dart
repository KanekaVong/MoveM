import '../../../../core/network/api_result.dart';
import '../../data/dto/request/create_trip_request.dart';
import '../../data/dto/response/trip_summary_response.dart';
import '../../data/dto/response/trip_response.dart';

abstract class TripRepository {
  Future<ApiResult<List<TripSummaryResponse>>> getMyTrips();

  Future<ApiResult<TripResponse>> createTrip(
      CreateTripRequest request,
      );
}