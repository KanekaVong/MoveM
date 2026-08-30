import '../../../../core/network/api_result.dart';
import '../../data/dto/response/invite_response.dart';

abstract class InviteRepository {
  Future<ApiResult<InviteResponse>> getInvite(String token);
  Future<ApiResult<InviteResponse>> createInvite();
}
