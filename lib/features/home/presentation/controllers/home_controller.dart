import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../domain/repositories/home_repository.dart';
import '../../data/dto/response/dashboard_response.dart';
import '../../data/services/home_service.dart';
import '../../data/repositories/home_repository_impl.dart';

class HomeController extends BaseController {
  final HomeRepository repository = HomeRepositoryImpl(HomeService());

  final Rx<DashboardResponse?> dashboardData = Rx<DashboardResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    await executeApi<DashboardResponse>(
      apiCall: () => repository.getDashboard(),
      onSuccess: (data) {
        dashboardData.value = data;
      },
      showLoading: false,
    );
  }
}
