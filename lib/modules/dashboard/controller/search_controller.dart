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
      return;
    }

    isLoading.value = true;

    try {
      // Perform all searches concurrently
      final searchFutures = [
        AuthRepository.searchUsers(query),
        AuthRepository.searchUsersByLocation(query),
        if (int.tryParse(query) != null)
          AuthRepository.searchUsersByAge(query),
      ];

      final searchResponses = await Future.wait(searchFutures);

      final combinedUsers = <SearchUser>{}; // Use a Set to handle duplicates

      for (final response in searchResponses) {
        if (response != null) {
          final model = SearchUserModel.fromJson(response);
          if (model.users != null) {
            combinedUsers.addAll(model.users!);
          }
        }
      }

      results.value = combinedUsers.toList();
    } catch (e) {
      results.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
