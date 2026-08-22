import 'package:get/get.dart';

class MainNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxList<int> visitedTabs = <int>[0].obs;

  void changeTab(int index) {
    currentIndex.value = index;
    if (!visitedTabs.contains(index)) {
      visitedTabs.add(index);
    }
  }
}
