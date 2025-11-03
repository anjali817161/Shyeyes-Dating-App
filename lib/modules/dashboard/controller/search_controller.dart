import 'package:get/get.dart';
import 'package:shyeyes/modules/dashboard/model/search_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class SearchFilterController extends GetxController {
  var isLoading = false.obs;
  var results = <SearchUser>[].obs;
  var selectedFilter = 'Name'.obs;

  Future<void> performSearch(String query) async {
    query = query.trim();

    if (query.isEmpty) {
      results.clear();
      isLoading.value = false;
      return;
    }

    isLoading.value = true;

    Map<String, dynamic>? response;

    // Perform search based on selected filter
    switch (selectedFilter.value) {
      case 'Name':
        response = await AuthRepository.searchUsers(query);
        break;
      case 'Location':
        response = await AuthRepository.searchUsersByLocation(query);
        break;
      case 'Age':
        // For age, try to parse as int, if not, treat as string
        final ageQuery = int.tryParse(query) != null ? query : null;
        if (ageQuery != null) {
          response = await AuthRepository.searchUsersByAge(ageQuery);
        } else {
          results.clear();
          isLoading.value = false;
          return;
        }
        break;
      case 'Gender':
        response = await AuthRepository.searchUsersByGender(query);
        break;
      default:
        response = await AuthRepository.searchUsers(query);
    }

    if (response != null) {
      final model = SearchUserModel.fromJson(response);
      results.value = model.users ?? [];
    } else {
      results.clear();
    }

    isLoading.value = false;
  }
}
