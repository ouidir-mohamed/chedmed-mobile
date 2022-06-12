import 'dart:convert';

class UserRequest {
  String username;
  String phone;
  UserRequest({
    required this.username,
    required this.phone,
  });

  UserRequest copyWith({
    String? username,
    String? phone,
  }) {
    return UserRequest(
      username: username ?? this.username,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone': phone,
    };
  }

  factory UserRequest.fromMap(Map<String, dynamic> map) {
    return UserRequest(
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  factory UserRequest.fromJson(String source) =>
      UserRequest.fromMap(json.decode(source));

  @override
  String toString() => 'UserRequest(username: $username, phone: $phone)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserRequest &&
        other.username == username &&
        other.phone == phone;
  }

  @override
  int get hashCode => username.hashCode ^ phone.hashCode;
}
