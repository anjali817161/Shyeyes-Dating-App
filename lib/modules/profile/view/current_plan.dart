import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/profile/controller/current_plan_controller.dart';

void showPlanBottomSheet(BuildContext context) {
  final ActivePlanController controller = Get.put(ActivePlanController());

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

          final plan = controller.activePlan.value;
          if (plan == null) {
            return const Center(child: Text("No Active Plan Found"));
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

Widget _buildPricingSection(plan) {
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
              "Start: ${plan.startDate?.toLocal().toString().split(' ').first ?? ''}",
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
              "End: ${plan.endDate?.toLocal().toString().split(' ').first ?? ''}",
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

Widget _buildFeaturesSection(plan) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Features',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 10),
      Container(
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildFeatureItem(
                "Messages per day: ${plan.limits?.messagesPerDay ?? 0}",
                Icons.message,
              ),
              _buildFeatureItem(
                "Video time: ${(plan.limits?.videoTimeSeconds ?? 0) ~/ 60} mins",
                Icons.video_call,
              ),
              _buildFeatureItem(
                "Audio time: ${(plan.limits?.audioTimeSeconds ?? 0) ~/ 60} mins",
                Icons.mic,
              ),
              _buildFeatureItem(
                "Matches allowed: ${plan.limits?.matchesAllowed ?? "Unlimited"}",
                Icons.favorite,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildFeatureItem(String text, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: Colors.green.shade700),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Icon(Icons.check_circle, color: Colors.green.shade600, size: 16),
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
              backgroundColor: Colors.transparent,
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
