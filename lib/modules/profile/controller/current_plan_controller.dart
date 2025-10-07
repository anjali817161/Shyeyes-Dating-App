import 'package:get/get.dart';
import 'package:shyeyes/modules/profile/model/current_plan_model.dart';
import 'package:shyeyes/modules/widgets/auth_repository.dart';

class ActivePlanController extends GetxController {
  var isLoading = false.obs;
  var activePlan = Rxn<Plan>();
  var daysLeft = 0.obs; // ✅ for countdown

  @override
  void onInit() {
    super.onInit();
    fetchActivePlan();
  }

  /// ✅ Fetch Active Plan API
  Future<void> fetchActivePlan() async {
    try {
      isLoading.value = true;
      final response = await AuthRepository.getActivePlan();

      if (response != null) {
        final model = ActivePlanModel.fromJson(response);
        if (model.plan != null) {
          activePlan.value = model.plan;
        } else {
          // ✅ If no plan found, set default free plan
          activePlan.value = _defaultFreePlan();
        }
      } else {
        activePlan.value = _defaultFreePlan();
      }

      _updateDaysLeft(); // auto update countdown
    } catch (e) {
      print("❌ Error fetching active plan: $e");
      activePlan.value = _defaultFreePlan();
      _updateDaysLeft();
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Default Free Plan (shown if user has no active plan)
  Plan _defaultFreePlan() {
    final now = DateTime.now();
    return Plan(
      planType: "Free",
      price: 0,
      durationDays: 7,
      isActive: true,
      startDate: now,
      endDate: now.add(const Duration(days: 7)),
      limits: Limits(
        messagesPerDay: 100,
        videoTimeSeconds: 0,
        audioTimeSeconds: 0,
        matchesAllowed: 10,
      ),
    );
  }

  /// ✅ Auto-update remaining days based on endDate
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
