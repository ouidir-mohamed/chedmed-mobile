import 'dart:convert';

import 'package:chedmed/models/conversation_user.dart';
import 'package:chedmed/utils/time_formatter.dart';
import 'package:flutter/foundation.dart';

import 'package:chedmed/models/message.dart';

class Conversation implements Comparable<Conversation> {
  int id;
  String createdAt;
  List<Message> messages;
  ConversationUser withUser;
  Conversation(
      {required this.id,
      required this.createdAt,
      required this.messages,
      required this.withUser});

  factory Conversation.fromJson(Map<String, dynamic> map) {
    return Conversation(
      id: map['id']?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
      messages: map['messages'] != null
          ? List<Message>.from(map['messages']?.map((x) => Message.fromJson(x)))
          : [],
      withUser: ConversationUser.fromJson(map['withUser']),
    );
  }

  @override
  String toString() =>
      'Conversation(id: $id, createdAt: $createdAt, messages: $messages)';

  @override
  int compareTo(Conversation other) {
    if (this.messages.isEmpty) return -1;
    if (other.messages.isEmpty) return 1;

    return other.messages.last.createdAt
        .toDateTime()
        .compareTo(this.messages.last.createdAt.toDateTime());
  }
}
