import 'package:chedmed/models/message_type.dart';
import 'package:chedmed/utils/time_formatter.dart';

import '../../models/message.dart';

class ChatBubblePresentation {
  String content;
  bool hasMarginTop;
  MessageDirection direction;
  String timeHeader;
  bool pending;
  MessageType type;
  String? voicePath;
  int? voiceDuration;

  ChatBubblePresentation(
      {required this.content,
      required this.hasMarginTop,
      required this.direction,
      required this.timeHeader,
      required this.pending,
      required this.type,
      this.voicePath,
      this.voiceDuration});

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
          type: m.type,
          timeHeader: timeHeader,
          pending: m.pending,
          voiceDuration: m.voiceDuration,
          voicePath: m.voicePath,
          direction:
              m.isSent ? MessageDirection.SENT : MessageDirection.RECEIVED));
    }).toList();
  }
}

enum MessageDirection { SENT, RECEIVED }

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
