import 'package:get/get.dart';
import 'package:shyeyes/modules/dashboard/model/search_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class SearchFilterController extends GetxController {
  var isLoading = false.obs;
  var results = <SearchUser>[].obs;

  Future<void> performSearch(String query) async {
    query = query.trim();

    if (query.isEmpty) {
      results.clear();
      isLoading.value = false; // make sure loader is off
      return;
    }

    isLoading.value = true;
    final response = await AuthRepository.searchUsers(query);

    if (response != null) {
      final model = SearchUserModel.fromJson(response);
      results.value = model.users ?? [];
    } else {
      results.clear();
    }

    isLoading.value = false;
  }
}
