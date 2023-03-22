class FireBaseConstants {
  static String serviceOrder = "serviceOrder";
  static String employees = "Employees";
  static String employee = "employee";
  static String status = "status";
  static String messages = "messages";
  static String supportChat = "supportChat";
  static String employeeNotifications = "employeeNotifications";
  static String serverKey =
      "AAAAcsoR5BA:APA91bErG1Nb6XMvRUERMyZ7TOD3X7XspXJNeiDvGbsRKH7vfT0TFfQo1oFzZJRIhfBEzvv4gxqJ5GX9DXG9zDOqxJbHhd4YZPvKCRtlhRaGgYnfJkqC2rRgR358YIIHLYh01rdf8zns";
  static String notificationApi = "https://fcm.googleapis.com/fcm/send";
}

enum OrderStatus { inProgress, pending, completed, canceled }
enum Status { init, loading, success, failed }
