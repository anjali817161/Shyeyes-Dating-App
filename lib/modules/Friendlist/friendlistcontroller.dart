import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/Friendlist/friendlistmodel.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';

class FriendController extends GetxController {
  var friends = <Friend>[].obs;
  var filteredFriends = <Friend>[].obs;
  var isLoading = false.obs;

  final searchController = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriends();

    /// searchController listener
    ever(searchController, (_) {
      filterFriends();
    });
  }

  Future<void> fetchFriends() async {
    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse(ApiEndpoints.baseUrl2 + ApiEndpoints.Friendlist),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        friends.value = data.map((e) => Friend.fromJson(e)).toList();
        filteredFriends.value = friends;
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterFriends() {
    String query = searchController.value.toLowerCase();
    if (query.isEmpty) {
      filteredFriends.value = friends;
    } else {
      filteredFriends.value = friends
          .where((f) => f.name.toLowerCase().contains(query))
          .toList();
    }
  }

  void deleteFriend(Friend friend) {
    friends.remove(friend);
    filteredFriends.remove(friend);
  }
}
