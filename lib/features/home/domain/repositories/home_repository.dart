import '../../../../core/network/api_result.dart';
import '../../data/dto/response/dashboard_response.dart';

abstract class HomeRepository {
  Future<ApiResult<DashboardResponse>> getDashboard();
}
