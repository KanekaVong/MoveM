import 'package:get/get.dart';
import '../../../../shared/base/base_controller.dart';
import '../../data/models/fitness_profile_model.dart';
import '../../data/models/fitness_statistics_model.dart';
import '../../data/models/solo_challenge_model.dart';
import '../../data/repositories/fitness_profile_repository.dart';
import '../../data/repositories/fitness_achievement_repository.dart';

class FitnessProfileController extends BaseController {
  final FitnessProfileRepository _repository = FitnessProfileRepository();
  final FitnessAchievementRepository _achievementRepository = FitnessAchievementRepository();

  final profile = Rxn<FitnessProfileModel>();
  final hasProfile = false.obs;

  final soloChallenges = <SoloChallengeModel>[].obs;
  final isLoadingChallenges = false.obs;

  final statistics = Rxn<FitnessStatisticsModel>();
  final isLoadingStatistics = false.obs;

  final achievementCount = 0.obs;

  final inputHeight = 0.0.obs;
  final inputWeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    fetchSoloChallenges();
    fetchStatistics();
    fetchAchievementCount();
  }

  Future<void> refreshData() async {
    await Future.wait([
      fetchProfile(),
      fetchSoloChallenges(),
      fetchStatistics(),
      fetchAchievementCount(),
    ]);
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
        if (data.height > 0 && data.weight > 0) {
          profile.value = data;
          hasProfile.value = true;
        } else {
          profile.value = data;
          hasProfile.value = false;
        }
      },
      onError: (e) {
        hasProfile.value = false;
      },
    );
  }

  Future<void> fetchStatistics() async {
    isLoadingStatistics.value = true;
    await executeApi<FitnessStatisticsModel>(
      showLoading: false,
      showErrorDialog: false,
      apiCall: () => _repository.getFitnessStatistics(),
      onSuccess: (data) {
        statistics.value = data;
        isLoadingStatistics.value = false;
      },
      onError: (e) {
        isLoadingStatistics.value = false;
      },
    );
  }

  Future<void> fetchAchievementCount() async {
    final result = await _achievementRepository.getMyAchievementCount();
    if (result.isSuccess && result.data != null) {
      achievementCount.value = result.data!;
    }
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
      },
      onError: (e) {
        success = false;
        Get.snackbar('Error', 'Failed to save profile. Please try again.');
      },
    );
    return success;
  }

  Future<bool> updateProfile(double height, double weight) async {
    bool success = false;
    await executeApi<FitnessProfileModel>(
      showLoading: false,
      apiCall: () => _repository.updateProfile(height, weight),
      onSuccess: (data) {
        profile.value = data;
        success = true;
      },
      onError: (e) {
        success = false;
        Get.snackbar('Error', 'Failed to update profile. Please try again.');
      },
    );
    return success;
  }

  Future<bool> saveBodyMetrics(double height, double weight) async {
    if (height < 50 || height > 300) {
      Get.snackbar('Error', 'Please enter a valid height in cm (e.g., 170 cm).');
      return false;
    }
    if (weight < 20 || weight > 500) {
      Get.snackbar('Error', 'Please enter a valid weight in kg (e.g., 65 kg).');
      return false;
    }

    if (hasProfile.value) {
      return updateProfile(height, weight);
    }

    bool success = false;
    await executeApi<FitnessProfileModel>(
      showLoading: false,
      apiCall: () => _repository.createProfile(height, weight),
      onSuccess: (data) {
        profile.value = data;
        hasProfile.value = true;
        success = true;
      },
      onError: (e) {
        success = false;
        Get.snackbar('Error', 'Failed to save profile. Please try again.');
      },
    );
    return success;
  }
}
