import 'package:get/get.dart';

import '../data/models/home_models.dart';
import '../data/services/home_api_service.dart';

class HomeController extends GetxController {
  HomeController(this._apiService);

  final HomeApiService _apiService;

  final Rxn<HomeResponse> homeResponse = Rxn<HomeResponse>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedNavIndex = 0.obs;

  Future<void> fetchHome() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _apiService.fetchHome();
      homeResponse.value = response;
      final apiSelectedIndex = response.data.bottomNav.indexWhere(
        (item) => item.selected,
      );
      if (apiSelectedIndex >= 0) selectedNavIndex.value = apiSelectedIndex;
    } catch (error) {
      errorMessage.value = error.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void selectNavigation(int index) {
    selectedNavIndex.value = index;
  }
}
