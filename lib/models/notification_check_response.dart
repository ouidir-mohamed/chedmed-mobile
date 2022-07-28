import 'dart:convert';

class NotificationCheckResponse {
  final bool available;
  final String title;
  final String message;
  NotificationCheckResponse({
    required this.available,
    required this.title,
    required this.message,
  });

  factory NotificationCheckResponse.fromJson(Map<String, dynamic> map) {
    return NotificationCheckResponse(
      available: map['available'] ?? false,
      message: map['message'] ?? '',
      title: map['title'] ?? '',
    );
  }
}
