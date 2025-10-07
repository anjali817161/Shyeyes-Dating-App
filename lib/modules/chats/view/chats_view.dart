import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shyeyes/modules/dashboard/model/dashboard_model.dart';
import 'package:shyeyes/modules/profile/controller/profile_controller.dart';
import 'package:zego_zim/zego_zim.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:shyeyes/modules/chats/view/heart_shape.dart';
import 'package:shyeyes/modules/chats/view/subscription_bottomsheet.dart';
import 'package:shyeyes/modules/chats/view/clientprofile.dart';

class ChatScreen extends StatefulWidget {
  final Users receiver; // दूसरे user की जानकारी
  const ChatScreen({required this.receiver, Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isConnecting = false;
  bool _isConnected = false;
  String? _connectionError;

  @override
  void initState() {
    super.initState();
    _connectUser();

    // Subscription dialog (optional)
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) _showSubscriptionDialog();
    });
  }

  /// ✅ Connect Current Logged-in User to Zego
  Future<void> _connectUser() async {
    if (_isConnecting) return;

    setState(() {
      _isConnecting = true;
      _connectionError = null;
    });

    try {
      final profileController = Get.find<ProfileController>();
      final currentUser = profileController.profile2.value?.data?.edituser;

      if (currentUser == null || currentUser.id == null || currentUser.id!.isEmpty) {
        throw Exception('Current user details not available. Please login again.');
      }

      final currentUserName =
          "${currentUser.name?.firstName ?? 'User'} ${currentUser.name?.lastName ?? ''}".trim();

      await ZIMKit().connectUser(
        id: currentUser.id!,
        name: currentUserName.isNotEmpty ? currentUserName : 'User',
      );

      setState(() {
        _isConnecting = false;
        _isConnected = true;
      });

      print('✅ Zego Connected as $currentUserName (${currentUser.id})');
    } catch (e) {
      print('❌ Zego Connection Error: $e');
      setState(() {
        _isConnecting = false;
        _isConnected = false;
        _connectionError = e.toString();
      });
    }
  }

  // 🔔 Subscription Dialog
  void _showSubscriptionDialog() {
    final theme = Theme.of(context);
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
                'Free Limit Exceeded',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Your free time is over. Please subscribe to continue.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => const SubscriptionBottomSheet(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
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

  // ⚙️ Connection Status UI
  Widget _buildConnectionStatus() {
    if (_isConnecting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Connecting to chat...', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Please wait', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (_connectionError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              const Text(
                'Connection Failed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                _connectionError!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _connectUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry Connection'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    if (!_isConnected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, color: Colors.blue, size: 60),
            const SizedBox(height: 16),
            const Text(
              'Chat Not Connected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _connectUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Connect to Chat'),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final receiver = widget.receiver;
    final peerID = receiver.id ?? '';

    if (peerID.isEmpty) {
      return Scaffold(
        backgroundColor: theme.colorScheme.secondary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text(
                'User Not Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('This user cannot be messaged.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: InkWell(
          onTap: () => UserBottomSheet.show(context),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  receiver.profilePic != null
                      ? "https://shyeyes-b.onrender.com/uploads/${receiver.profilePic!}"
                      : "https://i.pravatar.cc/150?img=65",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${receiver.name?.firstName ?? 'User'} ${receiver.name?.lastName ?? ''}",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _connectUser,
              tooltip: 'Reconnect',
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Lottie.asset(
                'assets/lotties/heart_fly.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: _isConnected && peerID.isNotEmpty
                    ? ZIMKitMessageListPage(
                        conversationID: peerID,
                        conversationType: ZIMConversationType.peer,
                      )
                    : _buildConnectionStatus(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
