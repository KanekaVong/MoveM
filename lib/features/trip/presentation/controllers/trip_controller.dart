import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/base/base_controller.dart';
import '../../../../core/utils/app_dialogs.dart';
import '../../data/dto/response/trip_summary_response.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../data/dto/request/create_trip_request.dart';

class TripController extends BaseController {
  static const String _tripWelcomeSeenKey = 'trip_welcome_seen';

  final TripRepository repository;

  TripController({
    required this.repository,
  });

  final List<TripSummaryResponse> recentTrips = [];

  Future<bool> shouldShowWelcome() async {
    final prefs = await SharedPreferences.getInstance();

    return !(prefs.getBool(_tripWelcomeSeenKey) ?? false);
  }

  Future<void> markWelcomeSeen() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_tripWelcomeSeenKey, true);
  }

  Future<void> getMyTrips() async {
    await executeApi(
      apiCall: () => repository.getMyTrips(),
      onSuccess: (data) {
        recentTrips
          ..clear()
          ..addAll(data);
      },
      showErrorDialog: false,
      onError: (e) {
        recentTrips.clear();
        AppDialogs.showError(e.message);
      },
    );
  }

  Future<void> createTrip(CreateTripRequest request) async {
    await executeApi(
      apiCall: () => repository.createTrip(request),
      onSuccess: (data) {
        AppDialogs.showSingleActionDialog(
          title: 'Trip Created',
          message: 'Your trip has been created successfully.',
        );
      },
      showErrorDialog: false,
      onError: (e) {
        AppDialogs.showError(e.message);
      },
    );
  }

}