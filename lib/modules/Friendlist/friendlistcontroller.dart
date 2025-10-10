import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/Friendlist/friendlistmodel.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class FriendController extends GetxController {
  var friends = <Friend>[].obs;
  var filteredFriends = <Friend>[].obs;
  var isLoading = false.obs;

  final searchController = "".obs;
  var isSearching = false.obs; // ✅ Add this for UI state management

  @override
  void onInit() {
    super.onInit();
    fetchFriends();

    // Search listener
    ever(searchController, (_) {
      filterFriends();
    });
  }

  final String apiUrl = ApiEndpoints.baseUrl2 + ApiEndpoints.Friendlist;

  Future<void> fetchFriends() async {
    final String token = await SharedPrefHelper.getToken() ?? "NULL";
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(apiUrl);
      print("body:----------${response.body}");
      print("status code:--------${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final model = FriendsModel.fromJson(data);

        friends.assignAll(model.data?.friends ?? []);
        filteredFriends.assignAll(friends);
      } else {
        Get.snackbar("Error", "Failed to fetch friends");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void filterFriends() {
    String query = searchController.value.toLowerCase();
    if (query.isEmpty) {
      filteredFriends.assignAll(friends);
    } else {
      filteredFriends.assignAll(
        friends.where((f) => (f.name ?? "").toLowerCase().contains(query)),
      );
    }
  }

  // ✅ Toggle search mode
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.value = ""; // Clear search when closing
    }
  }

  // ✅ Clear search
  void clearSearch() {
    searchController.value = "";
    isSearching.value = false;
  }

  /// ✅ Unfriend user and remove instantly from UI
  Future<void> unfriendFriend(String friendId) async {
    final String token = await SharedPrefHelper.getToken() ?? "NULL";

    try {
      isLoading.value = true;

      final url = "${ApiEndpoints.baseUrl2}${ApiEndpoints.unfriend}/$friendId";
      print(url);

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("body:----------${response.body}");
      print("status code:--------${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        Get.snackbar("Success", data["message"] ?? "Unfriended successfully");

        // ✅ Remove user instantly from both lists
        friends.removeWhere((f) => f.userId == friendId);
        filteredFriends.removeWhere((f) => f.userId == friendId);

        // 🔥 Force UI to update instantly
        friends.refresh();
        filteredFriends.refresh();
      } else {
        Get.snackbar("Error", "Failed to unfriend");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
