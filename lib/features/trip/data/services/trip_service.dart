import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../dto/request/create_trip_request.dart';

class TripService {
  final Dio dio = DioClient().dio;

  Future<Response> getMyTrips() async {
    return await dio.get(
      'trips',
      options: Options(responseType: ResponseType.plain),
    );
  }

  Future<Response> createTrip(CreateTripRequest request) async {
    return await dio.post(
      'trips',
      data: request.toJson(),
      options: Options(responseType: ResponseType.plain),
    );
  }
}