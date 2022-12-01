import 'dart:convert';

class TypingRequest {
  int recipientId;
  TypingRequest({
    required this.recipientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipientId': recipientId,
    };
  }
}
