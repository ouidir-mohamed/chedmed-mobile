import 'dart:convert';

class ConversationUser {
  int id;
  String username;
  ConversationUser({
    required this.id,
    required this.username,
  });

  factory ConversationUser.fromJson(Map<String, dynamic> map) {
    return ConversationUser(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
    );
  }

  @override
  String toString() => 'ConversationUser(id: $id, username: $username)';
}
