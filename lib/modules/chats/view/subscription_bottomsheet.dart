import 'package:flutter/material.dart';
import 'package:shyeyes/modules/payment/view/payment_view.dart';

class SubscriptionBottomSheet extends StatelessWidget {
  const SubscriptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final PageController controller = PageController(viewportFraction: 0.85);

    final plans = [
      {
        'title': 'Starter Love Plan',
        'price': '₹999',
        'subtext': '₹999 Now, then ₹1999 / Month',
        'features': [
          'View member profiles',
          'Send 10 messages daily',
          'Access public chat rooms',
          'Video calling feature',
          'Priority matchmaking',
          'Access exclusive events',
        ],
        'buttonText': 'Start Your Journey',
      },
      {
        'title': 'Romantic Silver Plan',
        'price': '₹2999',
        'subtext': '₹2999 Now, then ₹3999 / Month',
        'features': [
          'View member profiles',
          'Unlimited messaging',
          'Access public & private chat rooms',
          'Video calling feature',
          'Priority matchmaking',
          'Access exclusive events',
        ],
        'buttonText': 'Upgrade to Silver',
      },
      {
        'title': 'Premium Gold Love Plan',
        'price': '₹4999',
        'subtext': '₹4999 Now, then ₹5999 / Month',
        'features': [
          'View member profiles',
          'Unlimited messaging & media sharing',
          'Access all chat rooms (public & private)',
          'Video calling feature',
          'Priority matchmaking with AI',
          'Access exclusive SHY-EYES dating events',
        ],
        'buttonText': 'Go Premium Gold',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SHY-EYES Membership Plans',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            'Choose Your Perfect Dating Plan',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 440,
            child: PageView.builder(
              controller: controller,
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> plan = plans[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.secondary,
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                Text(
                                  plan['title']!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  plan['price']!,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  plan['subtext']!,
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...(plan['features']! as List<String>).map(
                                  (feature) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: theme.colorScheme.primary,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              PaymentPage(plan: plan['title']!),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      plan['buttonText']!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}
