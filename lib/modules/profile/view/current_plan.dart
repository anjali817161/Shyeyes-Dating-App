import 'package:flutter/material.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';

void showPlanBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Color(0xFFFFF3F3),
    context: context,
    isScrollControlled: true, // Changed to false as per your comment
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return SafeArea(
        child: Container(
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
                  SizedBox(height: 20),
                  _buildPlanTitle(),
                  SizedBox(height: 12),
                  _buildPricingSection(),
                  SizedBox(height: 20),
                  _buildFeaturesSection(),
                  SizedBox(height: 24),
                  _buildActionButtons(context),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
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
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade100,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
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
      // Cancel Icon - Top Right End
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
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.close, size: 20, color: Color(0xFFDF314D)),
        ),
      ),
    ],
  );
}

// Baaki sab widgets wahi rahenge...
Widget _buildPlanTitle() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Starter Love Plan',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 6),
      Container(
        height: 3,
        width: 50,
        decoration: BoxDecoration(
          color: Color(0xFFDF314D),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    ],
  );
}

Widget _buildPricingSection() {
  return Container(
    padding: EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.red.shade50,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '₹999',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.green.shade700,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'OFFER',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          '₹999 Now, then ₹1999 / Month',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
            SizedBox(width: 5),
            Text(
              'Validity: 1 Month',
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

Widget _buildFeaturesSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Features',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade50,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildFeatureItem('View member profiles', Icons.visibility),
              _buildFeatureItem('Send 10 messages daily', Icons.message),
              _buildFeatureItem('Access public chat rooms', Icons.chat),
              _buildFeatureItem('Video calling feature', Icons.video_call),
              _buildFeatureItem('Priority matchmaking', Icons.favorite),
              _buildFeatureItem('Access exclusive events', Icons.event),
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
        SizedBox(width: 8),
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
            Navigator.pop(
              context,
            ); // pehle current sheet band kar do (agar khuli hai)
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
          child: Text(
            'Upgrade Now',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      SizedBox(height: 8),
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
          child: Text(
            'Maybe Later',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ],
  );
}
