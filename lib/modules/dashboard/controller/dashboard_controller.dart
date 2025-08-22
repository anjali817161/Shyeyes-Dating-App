import 'package:get/get.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class ActiveUsersController extends GetxController {
  final AuthRepository _userRepository = AuthRepository();

  /// Observables
  var isLoading = false.obs;
  var activeUsers = <ActiveUserModel>[].obs; 
  var errorMessage = "".obs;
   var bestMatches = <BestMatchModel>[].obs;

  /// Fetch Active Users
  Future<void> fetchActiveUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final users = await _userRepository.getActiveUsers();
      activeUsers.assignAll(users);

      print("✅ Active users fetched: ${activeUsers.length}");
    } catch (e) {
      errorMessage.value = e.toString();
      print("❌ Error fetching active users: $e");
    } finally {
      isLoading.value = false;
    }
  }

   Future<void> fetchBestMatches() async {
    try {
      isLoading.value = true;
      final matches = await _userRepository.fetchBestMatches();
      bestMatches.assignAll(matches);
    } catch (e) {
      print("Error fetching matches: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
