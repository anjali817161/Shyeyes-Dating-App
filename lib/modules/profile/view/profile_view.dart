import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset('assets/images/logo.png', height: 50),
        ),
        // actions: [
        //   CircleAvatar(
        //     radius: 20,
        //     backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=15'),
        //   ),
        //   const SizedBox(width: 16),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildDoubleDateCard(),
            const SizedBox(height: 16),
            _buildBoostSection(),
            const SizedBox(height: 16),
            _buildGoldOrPlatinumCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 6.0,
          percent: 0.55,
          progressColor: theme.colorScheme.primary,
          backgroundColor: Colors.grey.shade300,
          circularStrokeCap: CircularStrokeCap.round,
          center: CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=15'),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Shaan, 22",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoubleDateCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: const [
          Icon(Icons.people, color: Color(0xFFF12F4F)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Try Double Date\nInvite your friends and find other pairs.",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildBoostSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildBoostCard(Icons.star, '0 Super Likes', 'GET MORE'),
        _buildBoostCard(Icons.flash_on, 'My Boosts', 'GET MORE'),
        _buildBoostCard(
          Icons.local_fire_department,
          'Subscriptions',
          'GET MORE',
        ),
      ],
    );
  }

  Widget _buildBoostCard(IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoldOrPlatinumCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow.shade200, Colors.amber],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                "ShyEyes",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(width: 4),
              Chip(
                label: Text('GOLD', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.black,
              ),
              Spacer(),
              Chip(label: Text('UPGRADE'), backgroundColor: Colors.redAccent),
            ],
          ),
          const SizedBox(height: 12),
          _buildFeatureRow("See Who Likes You", true),
          _buildFeatureRow("Top Picks", true),
          _buildFeatureRow("Free Super Likes", true),
          const SizedBox(height: 8),
          Center(
            child: Text(
              "See all Features",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text, bool isLocked) {
    return Row(
      children: [
        Icon(isLocked ? Icons.lock : Icons.check, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
        const Icon(Icons.check, color: Colors.black),
      ],
    );
  }
}
