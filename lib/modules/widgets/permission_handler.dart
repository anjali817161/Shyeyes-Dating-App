import 'package:permission_handler/permission_handler.dart';

Future<void> requestAppPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.nearbyWifiDevices,
    Permission.notification,
    Permission.phone,
  ].request();

  statuses.forEach((permission, status) {
    if (status.isDenied) {
      print("❌ Permission denied: $permission");
    } else if (status.isGranted) {
      print("✅ Permission granted: $permission");
    }
  });
}
