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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final model = FriendListModel.fromJson(data);
        friends.value = model.friends ?? [];
        filteredFriends.value = friends; // 👈 populate filtered list
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
      filteredFriends.value = friends;
    } else {
      filteredFriends.value = friends
          .where(
            (f) => (f.name ?? "").toLowerCase().contains(query),
          ) // 👈 null-safe
          .toList();
    }
  }

  Future<void> unfriendFriend(String friendId) async {
    final String token = await SharedPrefHelper.getToken() ?? "NULL";

    try {
      isLoading.value = true;
      print("${ApiEndpoints.baseUrl2}${ApiEndpoints.unfriend}/$friendId");
      print(token);

      final response = await http.delete(
        Uri.parse("${ApiEndpoints.baseUrl2}${ApiEndpoints.unfriend}/$friendId"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("body:----------${response.body}");
      print("status code:--------${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Snackbar message from API
        Get.snackbar("Success", data["message"] ?? "Unfriended successfully");

        // Local list se bhi remove karo
        friends.removeWhere((f) => f.id == friendId);
        filteredFriends.removeWhere((f) => f.id == friendId);
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
