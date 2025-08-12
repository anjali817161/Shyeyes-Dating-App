import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.15),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: theme.colorScheme.primary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 4,
                    radius: Radius.circular(8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 14),
                          Text(
                            'Welcome to Shy-Eyes — Your Trusted Dating Platform',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.indigo,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'By using our platform, you agree to the following terms and conditions. Please read them carefully before proceeding.',
                            style: TextStyle(fontSize: 15, height: 1.4),
                          ),
                          SizedBox(height: 18),
                          _TermItem(
                            number: '1.',
                            title: 'Age Requirement',
                            description:
                                'You must be at least 18 years old to register and use Shy-Eyes. We do not permit minors on our platform.',
                          ),
                          _TermItem(
                            number: '2.',
                            title: 'Respectful Behavior',
                            description:
                                'You agree to communicate respectfully and avoid any form of abuse, harassment, discrimination, or offensive content. Hateful speech or threats will result in immediate account suspension.',
                          ),
                          _TermItem(
                            number: '3.',
                            title: 'Authentic Information',
                            description:
                                'You must provide accurate, current, and truthful information during registration and profile setup. Fake or misleading information is strictly prohibited.',
                          ),
                          _TermItem(
                            number: '4.',
                            title: 'Subscription Fee',
                            description:
                                'All subscription fees are non-refundable. Once a payment is made, it cannot be reversed or returned, regardless of the level of usage or user satisfaction.',
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _TermItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.pink,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 15, height: 1.4),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
