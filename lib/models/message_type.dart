enum MessageType { TEXT, VOCAL, IMAGE }

extension MessageTypeSerialization on MessageType {
  String toJson() {
    switch (this) {
      case MessageType.TEXT:
        return "TEXT";
      case MessageType.IMAGE:
        return "IMAGE";
      case MessageType.VOCAL:
        return "VOCAL";
    }
  }

  static MessageType fromJson(String type) {
    switch (type) {
      case "TEXT":
        return MessageType.TEXT;
      case "IMAGE":
        return MessageType.IMAGE;
      case "VOCAL":
        return MessageType.VOCAL;
      default:
        return MessageType.TEXT;
    }
  }
}
