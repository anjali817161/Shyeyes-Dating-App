import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';

class Profile {
  final String name;
  final String imageUrl;
  Profile({required this.name, required this.imageUrl});
}

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  Future<List<Profile>> fetchLikedProfiles() async {
    await Future.delayed(const Duration(seconds: 1));
    return []; // return mock empty for now
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Likes"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: FutureBuilder<List<Profile>>(
        future: fetchLikedProfiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profiles = snapshot.data ?? [];

          if (profiles.isEmpty) {
            return _buildEmptyState(context, theme);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profile.imageUrl),
                    radius: 28,
                  ),
                  title: Text(profile.name),
                  trailing: Icon(Icons.favorite, color: theme.colorScheme.primary),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/like_button.json',
              height: 120,
              width: 120,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 16),
            const Text(
              "See people who liked you with ShyEye Gold™",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showSubscriptionDialog(context, theme);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                "See who likes you",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: HeartShapeBorder(),
        backgroundColor: theme.colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: theme.colorScheme.primary, size: 50),
              const SizedBox(height: 10),
              Text(
                'Subscription Required',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'To see who likes your profile, you have to subscribe your plan.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const SubscriptionBottomSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Subscribe Now',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
