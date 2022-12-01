import 'dart:convert';

class MessageRequest {
  int recipientId;
  String privateMessage;
  MessageRequest({
    required this.recipientId,
    required this.privateMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipientId': recipientId,
      'privateMessage': privateMessage,
    };
  }

  @override
  String toString() =>
      'MessageRequest(recipientId: $recipientId, privateMessage: $privateMessage)';

  @override
  int get hashCode => recipientId.hashCode ^ privateMessage.hashCode;
}
