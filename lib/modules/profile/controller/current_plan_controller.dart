import 'package:get/get.dart';
import 'package:shyeyes/modules/profile/model/current_plan_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class ActivePlanController extends GetxController {
  var isLoading = false.obs;
  var activePlan = Rxn<Plan>(); // ✅ Store current active plan

  @override
  void onInit() {
    super.onInit();
    fetchActivePlan();
  }

  /// Fetch Active Plan API
  Future<void> fetchActivePlan() async {
    try {
      isLoading.value = true;
      final response = await AuthRepository.getActivePlan(); 

      if (response != null) {
        final model = ActivePlanModel.fromJson(response);
        if (model.plan != null) {
          activePlan.value = model.plan;
        }
      }
    } catch (e) {
      print("❌ Error fetching active plan: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
