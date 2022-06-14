import 'dart:convert';

class UserProfile {
  int id;
  String username;
  String phone;
  UserProfile({
    required this.id,
    required this.username,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone': phone,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}