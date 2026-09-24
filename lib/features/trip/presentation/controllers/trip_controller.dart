import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/base/base_controller.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../data/dto/response/trip_summary_response.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../data/dto/request/create_trip_request.dart';
import '../../data/dto/response/trip_response.dart';
import 'package:get/get.dart';

class TripController extends BaseController {
  static const String _tripWelcomeSeenKey = 'trip_welcome_seen';
  TripResponse? selectedTrip;
  final TripRepository repository;

  TripController({
    required this.repository,
  });

  final RxList<TripSummaryResponse> recentTrips = <TripSummaryResponse>[].obs;

  Future<bool> shouldShowWelcome() async {
    final prefs = await SharedPreferences.getInstance();

    return !(prefs.getBool(_tripWelcomeSeenKey) ?? false);
  }

  Future<void> markWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_tripWelcomeSeenKey, true);
  }

  Future<void> getMyTrips({
    bool showLoading = true,
  }) async {
    await executeApi(
      apiCall: () => repository.getMyTrips(),
      onSuccess: (data) {
        recentTrips
          ..clear()
          ..addAll(data);
      },
      showLoading: showLoading,
      showErrorDialog: false,
      onError: (e) {
        recentTrips.clear();
        AppDialogs.showError(e.message);
      },
    );
  }

  Future<bool> getTripDetail(String activityId) async {
    var success = false;

    await executeApi(
      apiCall: () => repository.getTripDetail(activityId),
      onSuccess: (data) {
        selectedTrip = data;
        success = true;
      },
      showErrorDialog: false,
      onError: (e) {
        AppDialogs.showError(e.message);
      },
    );

    return success;
  }

  Future<bool> createTrip(CreateTripRequest request) async {
    var success = false;

    await executeApi(
      apiCall: () => repository.createTrip(request),
      onSuccess: (_) {
        success = true;
      },
      showErrorDialog: false,
      onError: (e) {
        AppDialogs.showError(e.message);
      },
    );

    return success;
  }

  Future<bool> deleteTrip(String activityId) async {
    var success = false;

    await executeApi(
      apiCall: () => repository.deleteTrip(activityId),
      onSuccess: (_) {
        recentTrips.removeWhere(
              (trip) => trip.activityId == activityId,
        );

        success = true;
      },
      showErrorDialog: false,
      onError: (e) {
        AppDialogs.showError(e.message);
      },
    );

    return success;
  }

}