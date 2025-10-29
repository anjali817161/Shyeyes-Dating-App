import 'package:get/get.dart';
import 'package:shyeyes/modules/profile/model/current_plan_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class ActivePlanController extends GetxController {
  var isLoading = false.obs;
  var activePlan = Rxn<Plan>();
  var daysLeft = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActivePlan();
  }

  Future<void> fetchActivePlan() async {
    try {
      isLoading.value = true;
      final response = await AuthRepository.getActivePlan();

      if (response != null) {
        final model = ActivePlanModel.fromJson(response);
        if (model.plan != null) {
          activePlan.value = model.plan;
          _updateDaysLeft();
        } else {
          activePlan.value = null; // ❌ no plan at all
        }
      } else {
        activePlan.value = null;
      }
    } catch (e) {
      print("❌ Error fetching active plan: $e");
      activePlan.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasActivePaidPlan {
    final plan = activePlan.value;
    if (plan == null) return false; // ❌ no plan
    final planType = plan.planType?.toLowerCase() ?? '';
    if (planType.contains('free')) return false; // ❌ free plan
    return plan.isActive == true; // ✅ active paid plan
  }

  void _updateDaysLeft() {
    final plan = activePlan.value;
    if (plan?.endDate != null) {
      final remaining = plan!.endDate!.difference(DateTime.now()).inDays;
      daysLeft.value = remaining > 0 ? remaining : 0;
    } else {
      daysLeft.value = 0;
    }
  }
}
