import '../../models/message.dart';
import 'package:chedmed/utils/time_formatter.dart';

class ChatBubblePresentation {
  String content;
  bool hasMarginTop;
  MessageType type;
  String timeHeader;
  bool pending;
  ChatBubblePresentation(
      {required this.content,
      required this.type,
      required this.hasMarginTop,
      required this.timeHeader,
      required this.pending});

  static List<ChatBubblePresentation> fromMessages(List<Message> messages) {
    return messages.asMap().entries.map((entery) {
      int index = entery.key;
      Message m = entery.value;

      bool hasMarginTop = false;
      String timeHeader = "";
      if (index > 0) {
        if (messages[index - 1].isSent != m.isSent) hasMarginTop = true;
        timeHeader = generateTimeHeader(
          m,
          first: messages[index - 1],
        );
      } else {
        timeHeader = generateTimeHeader(
          m,
        );
      }

      return (ChatBubblePresentation(
          content: m.body,
          hasMarginTop: hasMarginTop,
          timeHeader: timeHeader,
          pending: m.pending,
          type: m.isSent ? MessageType.SENT : MessageType.RECEIVED));
    }).toList();
  }
}

enum MessageType { SENT, RECEIVED }

String generateTimeHeader(Message last, {Message? first}) {
  if (first == null) {
    return last.createdAt.toDateTime().messageTimeString();
  }
  if (last.createdAt
          .toDateTime()
          .difference(first.createdAt.toDateTime())
          .inMinutes >
      30) return last.createdAt.toDateTime().messageTimeString();
  ;
  return "";
}
