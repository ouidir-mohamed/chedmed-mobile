import 'dart:convert';

class UserResponse {
  int id;
  String username;
  String token;
  UserResponse({
    required this.id,
    required this.username,
    required this.token,
  });

  UserResponse copyWith({
    int? id,
    String? username,
    String? token,
  }) {
    return UserResponse(
      id: id ?? this.id,
      username: username ?? this.username,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'token': token,
    };
  }

  factory UserResponse.fromJson(Map<String, dynamic> map) {
    return UserResponse(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'UserResponse(id: $id, username: $username, token: $token)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserResponse &&
        other.id == id &&
        other.username == username &&
        other.token == token;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ token.hashCode;
}
