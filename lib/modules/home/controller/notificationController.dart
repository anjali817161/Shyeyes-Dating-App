import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Reactive variable for count
  static var notificationCount = 3;

  // Method to update count
  void setCount(int count) {
    notificationCount = count;
  }

  // Optional: increment
  void increment() {
    notificationCount++;
  }

  // Optional: clear
  void clear() {
    notificationCount = 0;
  }
}
