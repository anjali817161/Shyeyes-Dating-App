import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/profile/controller/current_plan_controller.dart';
import 'package:intl/intl.dart';
import 'package:shyeyes/modules/profile/model/current_plan_model.dart';

void showPlanBottomSheet(BuildContext context) {
final ActivePlanController controller = Get.put(ActivePlanController(), permanent: true);
  controller.fetchActivePlan(); 
  showModalBottomSheet(
    backgroundColor: const Color(0xFFFFF3F3),
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Use API plan or fallback Free plan
          final plan = controller.activePlan.value;

          if (plan == null) {
            // 🚫 No plan case
            return _buildNoPlanView(context);
          }

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.95,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 20),
                    _buildPlanTitle(plan.planType ?? "Unknown"),
                    const SizedBox(height: 12),
                    _buildPricingSection(plan),
                    const SizedBox(height: 20),
                    _buildFeaturesSection(plan),
                    const SizedBox(height: 24),
                    _buildActionButtons(context),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}

Widget _buildNoPlanView(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.45,
    padding: const EdgeInsets.all(24),
    decoration: const BoxDecoration(
      color: Color(0xFFFFF3F3),
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline, size: 60, color: Color(0xFFDF314D)),
        const SizedBox(height: 16),
        const Text(
          'No Active Plan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Subscribe to a plan to unlock premium features.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const SubscriptionBottomSheet(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDF314D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Subscribe Now',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// /// ✅ Default free plan model
// _getDefaultFreePlan() {
//   return Plan(
//     planType: "Free Plan",
//     price: 0,
//     durationDays: 30,
//     isActive: true,
//     startDate: DateTime.now(),
//     endDate: DateTime.now().add(const Duration(days: 30)),
//     limits: Limits(
//       messagesPerDay: 10,
//       videoTimeSeconds: 60 * 5,
//       audioTimeSeconds: 60 * 5,
//       matchesAllowed: 5,
//     ),
//   );
// }

Widget _buildHeader(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade100,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Active Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDF314D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.shade100,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.close, size: 20, color: Color(0xFFDF314D)),
        ),
      ),
    ],
  );
}

Widget _buildPlanTitle(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        height: 3,
        width: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFDF314D),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ],
  );
}

Widget _buildPricingSection(Plan plan) {
  int? daysLeft;
  if (plan.endDate != null) {
    final now = DateTime.now();
    daysLeft = plan.endDate!.difference(now).inDays;
    if (daysLeft < 0) daysLeft = 0;
  }

  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.red.shade50,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "₹${plan.price ?? 0}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                plan.isActive == true ? "ACTIVE" : "INACTIVE",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ),
            const Spacer(),
            if (daysLeft != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDF314D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "$daysLeft days left",
                  style: const TextStyle(
                    color: Color(0xFFDF314D),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Validity: ${plan.durationDays ?? 0} Days",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              "Start: ${plan.startDate != null ? DateFormat('yyyy-MM-dd').format(plan.startDate!) : '-'}",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.calendar_month, size: 14, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              "End: ${plan.endDate != null ? DateFormat('yyyy-MM-dd').format(plan.endDate!) : '-'}",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildFeaturesSection(Plan plan) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Plan Features & Usage',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 12),

      // Total Limits Section
      _buildFeatureCategory(
        title: "Total Limits",
        icon: Icons.lock_outline,
        children: [
          _buildFeatureRow(
            "Messages per day",
            "${plan.limits?.messagesPerDay ?? 0}",
            Icons.message,
          ),
          _buildFeatureRow(
            "Video time",
            "${(plan.limits?.videoTimeSeconds ?? 0) ~/ 60} mins",
            Icons.video_call,
          ),
          _buildFeatureRow(
            "Audio time",
            "${(plan.limits?.audioTimeSeconds ?? 0) ~/ 60} mins",
            Icons.mic,
          ),
          _buildFeatureRow(
            "Matches allowed",
            "${plan.limits?.matchesAllowed ?? "Unlimited"}",
            Icons.favorite,
          ),
        ],
      ),

      const SizedBox(height: 16),

      // Usage Section - Only show if usage data exists
      if (plan.usage != null)
        _buildFeatureCategory(
          title: "Current Usage",
          icon: Icons.analytics_outlined,
          children: [
            if (plan.usage?.messages != null)
              _buildUsageRow(
                "Messages",
                "${plan.usage?.messages?.used ?? 0}",
                "${plan.usage?.messages?.remaining ?? 0}",
                Icons.message,
              ),
            if (plan.usage?.audio != null)
              _buildUsageRow(
                "Audio",
                "${plan.usage?.audio?.used ?? 0}",
                "${plan.usage?.audio?.remaining ?? 0}",
                Icons.mic,
              ),
            if (plan.usage?.video != null)
              _buildUsageRow(
                "Video",
                "${plan.usage?.video?.used ?? 0}",
                "${plan.usage?.video?.remaining ?? 0}",
                Icons.video_call,
              ),
          ],
        ),
    ],
  );
}

Widget _buildFeatureCategory({
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.red.shade50,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFDF314D).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: const Color(0xFFDF314D)),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Features List
          Column(children: children),
        ],
      ),
    ),
  );
}

Widget _buildFeatureRow(String feature, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: Colors.green.shade700),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            feature,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.green.shade700,
          ),
        ),
      ],
    ),
  );
}

Widget _buildUsageRow(
  String type,
  String used,
  String remaining,
  IconData icon,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: Colors.blue.shade700),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Used: $used • Remaining: $remaining",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionButtons(BuildContext context) {
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              builder: (_) => const SubscriptionBottomSheet(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Upgrade Now',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: double.infinity,
        height: 44,
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Maybe Later',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ],
  );
}
