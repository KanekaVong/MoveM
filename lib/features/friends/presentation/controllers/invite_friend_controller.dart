import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/storage/user_manager.dart';
import '../../../../shared/base/base_controller.dart';
import '../../../auth/data/dto/response/user_response.dart';
import '../../data/dto/response/invite_response.dart';
import '../../data/repositories/invite_repository_impl.dart';
import '../../data/services/invite_service.dart';
import '../../domain/repositories/invite_repository.dart';

class InviteFriendController extends BaseController {
  final InviteRepository repository;

  InviteFriendController({InviteRepository? repository})
      : repository = repository ?? InviteRepositoryImpl(InviteService());

  final RxString inviteLink = ''.obs;
  final RxString inviteToken = ''.obs;
  final Rx<UserResponse?> currentUser = Rx<UserResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadUserAndInitDefaults();
    fetchOrCreateInvite();
  }

  void _loadUserAndInitDefaults() {
    currentUser.value = UserManager().getUser();
    final user = currentUser.value;
    final fallbackToken = user?.id.isNotEmpty == true
        ? user!.id
        : (user?.username.isNotEmpty == true ? user!.username : '1d7f1d9de508405183d26646ds');
    inviteToken.value = fallbackToken;
    inviteLink.value = 'https://movem.app/invite/$fallbackToken';
  }

  Future<void> fetchOrCreateInvite() async {
    state.value = ViewState.loading;

    // First attempt to create an invite link from API
    final result = await repository.createInvite();

    if (result is ApiSuccess<InviteResponse>) {
      _applyInviteData(result.data);
      state.value = ViewState.success;
    } else if (result is ApiError<InviteResponse>) {
      // If create returns error, try fetching by token or keep default
      final token = inviteToken.value;
      if (token.isNotEmpty) {
        final getResult = await repository.getInvite(token);
        if (getResult is ApiSuccess<InviteResponse>) {
          _applyInviteData(getResult.data);
          state.value = ViewState.success;
          return;
        }
      }
      state.value = ViewState.success; // Soft fallback
    }
  }

  void _applyInviteData(InviteResponse data) {
    if (data.inviteUrl.isNotEmpty) {
      inviteLink.value = data.inviteUrl;
      final uri = Uri.tryParse(data.inviteUrl);
      if (uri != null && uri.pathSegments.isNotEmpty) {
        inviteToken.value = uri.pathSegments.last;
      }
    }
  }

  void copyInviteLink() {
    Clipboard.setData(ClipboardData(text: inviteLink.value));
    Get.snackbar(
      'Copied',
      'Invite link copied to clipboard',
      backgroundColor: const Color(0xFF1E293B).withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void copyToken() {
    Clipboard.setData(ClipboardData(text: inviteToken.value));
    Get.snackbar(
      'Copied',
      'Invite token copied to clipboard',
      backgroundColor: const Color(0xFF1E293B).withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> shareVia(String platform) async {
    final link = inviteLink.value;
    final message = 'Join me on MoveM! Move with purpose. Use my invite link: $link';

    switch (platform.toLowerCase()) {
      case 'telegram':
        final url = Uri.parse('https://t.me/share/url?url=${Uri.encodeComponent(link)}&text=${Uri.encodeComponent("Join me on MoveM! Move with purpose.")}');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          await Share.share(message);
        }
        break;

      case 'facebook':
        final url = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(link)}');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          await Share.share(message);
        }
        break;

      case 'messenger':
        final url = Uri.parse('fb-messenger://share/?link=${Uri.encodeComponent(link)}');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          await Share.share(message);
        }
        break;

      case 'instagram':
      case 'tiktok':
        // Direct deep-link sharing with fallback to system share
        await Share.share(message);
        break;

      case 'more':
      default:
        await Share.share(message);
        break;
    }
  }
}
