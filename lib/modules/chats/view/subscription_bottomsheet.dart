import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/payment/view/payment_view.dart';
import 'package:shyeyes/modules/subscription/controller/subscription_controller.dart';

class SubscriptionBottomSheet extends StatefulWidget {
  const SubscriptionBottomSheet({super.key});

  @override
  State<SubscriptionBottomSheet> createState() =>
      _SubscriptionBottomSheetState();
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet> {
  final PlanController planController = Get.put(PlanController());
  late PageController pageController;
  final RxInt currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    pageController = PageController(viewportFraction: 0.8);

    pageController.addListener(() {
      int page = pageController.page?.round() ?? 0;
      currentPage.value = page;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (planController.isLoading.value) {
        return SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final plans = planController.plansList;

      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      'SHY-EYES Membership Plans',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Choose Your Perfect Dating Plan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return AnimatedPadding(
                      duration: Duration(milliseconds: 300),
                      padding: EdgeInsets.all(
                        currentPage.value == index ? 0 : 8,
                      ),
                      child: Material(
                        elevation: currentPage.value == index ? 8 : 4,
                        borderRadius: BorderRadius.circular(20),
                        shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: theme.colorScheme.secondary,
                            border: currentPage.value == index
                                ? Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3),
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(18),
                                  ),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.primary.withOpacity(
                                        0.8,
                                      ),
                                    ],
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 16, // Added horizontal padding
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      plan.planType?.capitalizeFirst ?? '',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      '₹${plan.price}',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      'Validity: ${plan.durationDays} days',
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary
                                            .withOpacity(0.9),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (plan.limits != null) ...[
                                        _buildFeatureItem(
                                          'Messages per day: ${plan.limits!.messagesPerDay}',
                                          theme,
                                        ),
                                        _buildFeatureItem(
                                          'Video Time: ${plan.limits!.videoTimeSeconds}s',
                                          theme,
                                        ),
                                        _buildFeatureItem(
                                          'Audio Time: ${plan.limits!.audioTimeSeconds}s',
                                          theme,
                                        ),
                                        _buildFeatureItem(
                                          'Matches Allowed: ${plan.limits!.matchesAllowed ?? "Unlimited"}',
                                          theme,
                                        ),
                                      ],
                                      Spacer(),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                theme.colorScheme.primary,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 2,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PaymentPage(
                                                  plan: plan.planType ?? '',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Select Plan',
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Enhanced Pagination Dots with proper spacing
              SizedBox(height: 16),
              Obx(() {
                if (plans.isEmpty) return SizedBox();

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(plans.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: currentPage.value == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentPage.value == index
                                ? theme.colorScheme.primary
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: currentPage.value == index
                                ? [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
              // Additional pagination dots row for better visibility
              Obx(() {
                if (plans.length <= 5)
                  return SizedBox(); // Show only if many plans

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(plans.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: currentPage.value == index
                              ? theme.colorScheme.primary
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                );
              }),
              SizedBox(height: 8),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFeatureItem(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: theme.colorScheme.primary,
              size: 16,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
