import 'dart:convert';

class ConversationRequest {
  int recipientId;
  ConversationRequest({
    required this.recipientId,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipientId': recipientId,
    };
  }

  @override
  String toString() => 'ConversationRequest(recipientId: $recipientId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationRequest && other.recipientId == recipientId;
  }

  @override
  int get hashCode => recipientId.hashCode;
}
