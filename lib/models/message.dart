import 'dart:convert';

import 'package:chedmed/models/message_type.dart';
import 'package:chedmed/utils/time_formatter.dart';

class Message implements Comparable<Message> {
  int id;
  String? userName;
  String body;
  bool seen;
  String createdAt;
  bool isSent;
  bool pending;
  MessageType type;

  int conversation_id;
  String? voicePath;
  int? voiceDuration;

  Message(
      {required this.id,
      this.userName,
      required this.body,
      required this.seen,
      required this.createdAt,
      required this.isSent,
      required this.pending,
      required this.conversation_id,
      required this.type,
      this.voicePath,
      this.voiceDuration});

  factory Message.fromJson(Map<String, dynamic> map) {
    return Message(
      id: map['id']?.toInt() ?? 0,
      userName: map['userName'] ?? null,
      body: map['body'] ?? '',
      seen: map['seen'] ?? false,
      createdAt: map['createdAt'] ?? '',
      isSent: map['isSent'] ?? false,
      pending: false,
      conversation_id: map['conversation_id'] ?? 0,
      type: MessageTypeSerialization.fromJson(map['type']),
      voiceDuration: map['voiceDuration'],
      voicePath: map['voicePath'],
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, body: $body, seen: $seen, createdAt: $createdAt, isSent: $isSent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        body.hashCode ^
        seen.hashCode ^
        createdAt.hashCode ^
        isSent.hashCode ^
        conversation_id.hashCode;
  }

  @override
  int compareTo(Message other) {
    return this.createdAt.toDateTime().compareTo(other.createdAt.toDateTime());
  }
}
