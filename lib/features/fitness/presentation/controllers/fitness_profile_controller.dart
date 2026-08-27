import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/models/fitness_profile_model.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/repositories/fitness_profile_repository.dart';

class FitnessProfileController extends BaseController {
  final FitnessProfileRepository _repository = FitnessProfileRepository();

  final profile = Rxn<FitnessProfileModel>();
  final hasProfile = false.obs;

  final soloChallenges = <SoloChallengeModel>[].obs;
  final isLoadingChallenges = false.obs;

  final inputHeight = 0.0.obs;
  final inputWeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchSoloChallenges();
  }

  Future<void> fetchSoloChallenges() async {
    isLoadingChallenges.value = true;
    await executeApi<List<SoloChallengeModel>>(
      showLoading: false,
      showErrorDialog: false,
      apiCall: () => _repository.getSoloChallenges(),
      onSuccess: (data) {
        soloChallenges.value = data;
        isLoadingChallenges.value = false;
      },
      onError: (e) {
        isLoadingChallenges.value = false;
      },
    );
  }

  Future<void> fetchProfile() async {
    await executeApi<FitnessProfileModel>(
      showLoading: false,
      showErrorDialog: false,
      apiCall: () => _repository.getProfile(),
      onSuccess: (data) {
        profile.value = data;
        if (data.height > 0 && data.weight > 0) {
          hasProfile.value = true;
        } else {
          hasProfile.value = false;
        }
      },
      onError: (e) {
        hasProfile.value = false;
      },
    );
  }

  void setHeight(double cm) {
    inputHeight.value = cm;
  }

  void setWeight(double kg) {
    inputWeight.value = kg;
  }

  Future<bool> saveProfile() async {
    if (inputHeight.value < 50 || inputHeight.value > 300) {
      Get.snackbar('Error', 'Please enter a valid height in cm (e.g., 170 cm). If using ft, ensure it converts to a reasonable value.');
      return false;
    }
    if (inputWeight.value < 20 || inputWeight.value > 500) {
      Get.snackbar('Error', 'Please enter a valid weight in kg (e.g., 65 kg).');
      return false;
    }

    bool success = false;
    await executeApi<FitnessProfileModel>(
      apiCall: () => _repository.createProfile(inputHeight.value, inputWeight.value),
      onSuccess: (data) {
        profile.value = data;
        hasProfile.value = true;
        success = true;
        Get.back();
      },
    );
    return success;
  }
}
