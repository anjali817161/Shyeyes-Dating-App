import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shyeyes/modules/payment/success/view/succes_page.dart';

class PaymentPage extends StatefulWidget {
  final String plan;
  const PaymentPage({Key? key, required this.plan}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController utrController = TextEditingController();
  bool showQrSection = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F3),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // QR Section - only visible when showQrSection is true
                if (showQrSection) ...[
                  RichText(
                    text: TextSpan(
                      text: 'Scan & Pay for ',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: widget.plan,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_2,
                        size: 250,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: utrController,
                    decoration: InputDecoration(
                      labelText: 'Enter UTR/Transaction ID',
                      labelStyle: const TextStyle(color: Colors.black54),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'UPI: demo@upi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'Use any UPI app to pay',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (utrController.text.isNotEmpty) {
                        Get.to(() => const SuccessPage());
                      } else {
                        Get.snackbar(
                          'UTR Required',
                          'Please enter your transaction ID before continuing.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Make Payment",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                ],

                const Text(
                  "Other Payment Options",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildPaymentOption(Icons.qr_code, "Pay through QR", theme, () {
                      setState(() {
                        showQrSection = true;
                      });
                    }),
                    _buildPaymentOption(Icons.account_balance_wallet, "Paytm UPI", theme, () {}),
                    _buildPaymentOption(Icons.payment, "Google Pay", theme, () {}),
                    _buildPaymentOption(Icons.account_balance, "PhonePe", theme, () {}),
                    _buildPaymentOption(Icons.credit_card, "Credit / Debit Card", theme, () {}),
                    _buildPaymentOption(Icons.language, "Net Banking", theme, () {}),
                    _buildPaymentOption(Icons.wallet, "Amazon Pay", theme, () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title, ThemeData theme, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
