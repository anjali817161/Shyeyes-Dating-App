import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      "name": "Ram",
      "message": "is active now",
      "time": "2m ago",
      "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
      "icon": Icons.circle, // Active status
      "iconColor": Colors.green
    },
    {
      "name": "Priya",
      "message": "accepted your request",
      "time": "5m ago",
      "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
      "icon": Icons.check_circle,
      "iconColor": Colors.blue
    },
    {
      "name": "Amit",
      "message": "liked your profile",
      "time": "10m ago",
      "avatar": "https://randomuser.me/api/portraits/men/67.jpg",
      "icon": Icons.favorite,
      "iconColor": Colors.red
    },
    {
      "name": "Neha",
      "message": "sent you a message",
      "time": "15m ago",
      "avatar": "https://randomuser.me/api/portraits/women/12.jpg",
      "icon": Icons.message,
      "iconColor": Colors.purple
    },
    {
      "name": "Raj",
      "message": "viewed your profile",
      "time": "20m ago",
      "avatar": "https://randomuser.me/api/portraits/men/88.jpg",
      "icon": Icons.remove_red_eye,
      "iconColor": Colors.orange
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Container(
        color: theme.colorScheme.secondary,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(notif["avatar"]),
                      radius: 26,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(
                          notif["icon"],
                          color: notif["iconColor"],
                          size: 14,
                        ),
                      ),
                    )
                  ],
                ),
                title: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: notif["name"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " ${notif["message"]}"),
                    ],
                  ),
                ),
                subtitle: Text(
                  notif["time"],
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                onTap: () {
                  print("Tapped on ${notif["name"]}");
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
