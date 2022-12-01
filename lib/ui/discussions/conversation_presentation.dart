import '../../models/conversation.dart';
import 'package:chedmed/utils/time_formatter.dart';

class ConversationPresentation {
  int id;
  String username;
  int userId;
  String content;
  bool seenByUser;
  bool seenByReceiver;

  String time;
  bool isSent;
  ConversationPresentation({
    required this.id,
    required this.username,
    required this.userId,
    required this.content,
    required this.seenByUser,
    required this.seenByReceiver,
    required this.time,
    required this.isSent,
  });

  static ConversationPresentation? fromConversation(Conversation conversation) {
    if (conversation.messages.isEmpty) return null;

    return ConversationPresentation(
        id: conversation.id,
        username: conversation.withUser.username,
        userId: conversation.withUser.id,
        content: (conversation.messages.last.isSent ? "You: " : "") +
            conversation.messages.last.body,
        seenByUser: conversation.messages.last.seen ||
            conversation.messages.last.isSent,
        seenByReceiver: conversation.messages.last.seen &&
            conversation.messages.last.isSent,
        time: conversation.messages.last.createdAt
            .toDateTime()
            .messageTimeString(),
        isSent: conversation.messages.last.isSent);
  }
}
