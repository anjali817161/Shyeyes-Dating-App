import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shyeyes/modules/Friendlist/friendlistmodel.dart';
import 'package:shyeyes/modules/invitation/model/invitation_model.dart';
import 'package:shyeyes/modules/likes/showlikesmodel.dart';
import 'package:shyeyes/modules/widgets/api_endpoints.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';
import 'package:shyeyes/modules/widgets/sharedPrefHelper.dart';

class NotificationsController extends GetxController {
  var allNotifications = <Map<String, dynamic>>[].obs;
  var requests = <Map<String, dynamic>>[].obs;
  var likes = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllNotifications();
  }

  Future<void> fetchAllNotifications() async {
    isLoading.value = true;
    allNotifications.clear();

    try {
      await Future.wait([_fetchFriends(), _fetchRequests(), _fetchLikes()]);

      // ✅ Combine all notifications in one list
      allNotifications.assignAll([
        ...requests,
        ...likes,
        ...friends.map(
          (f) => {
            "name": f.name ?? "User",
            "message": "is active now",
            "avatar": f.profilePic ?? "https://i.pravatar.cc/150?img=2",
            "type": "friend",
          },
        ),
      ]);
    } catch (e) {
      print("❌ Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ---------- FRIENDS ----------
  var friends = <Friend>[].obs;
  Future<void> _fetchFriends() async {
    final String token = await SharedPrefHelper.getToken() ?? "NULL";
    final String url = ApiEndpoints.baseUrl2 + ApiEndpoints.Friendlist;
    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final model = FriendsModel.fromJson(jsonDecode(res.body));
        friends.assignAll(model.data?.friends ?? []);
      }
    } catch (e) {
      print("Error fetching friends: $e");
    }
  }

  /// ---------- REQUESTS ----------
  Future<void> _fetchRequests() async {
    try {
      final response = await AuthRepository.getInvitations();
      if (response != null && response['requests'] != null) {
        final List<RequestsResponse> invites = (response['requests'] as List)
            .map((e) => RequestsResponse.fromJson(e))
            .toList();

        requests.assignAll(
          invites.map(
            (r) => {
              "name": r.user1?.name?.firstName ?? "Unknown",
              "message": "sent you a friend request",
              "avatar":
                  r.user1?.profilePic ?? "https://i.pravatar.cc/150?img=5",
              "type": "request",
            },
          ),
        );
      }
    } catch (e) {
      print("Error fetching requests: $e");
    }
  }

  /// ---------- LIKES ----------
  Future<void> _fetchLikes() async {
    try {
      final token = await SharedPrefHelper.getToken();
      if (token == null) return;

      final res = await AuthRepository().Showlikesprofiles(token);

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        final data = showlikes.fromJson(jsonData);

        likes.assignAll(
          (data.rlikes ?? []).map(
            (l) => {
              "name": l.liker?.name ?? "User",
              "message": "liked your profile",
              "avatar":
                  l.liker?.profilePic ?? "https://i.pravatar.cc/150?img=9",
              "type": "like",
            },
          ),
        );
      }
    } catch (e) {
      print("Error fetching likes: $e");
    }
  }
}
