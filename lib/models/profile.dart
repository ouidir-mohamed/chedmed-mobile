import 'dart:convert';

class UserProfile {
  int id;
  String username;
  String phone;
  int nbPost;
  int nbFavorite;
  int nbViews;

  UserProfile({
    required this.id,
    required this.username,
    required this.phone,
    required this.nbPost,
    required this.nbFavorite,
    required this.nbViews,
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
      nbFavorite: map['nbFavorite'] ?? '',
      nbPost: map['nbPost'] ?? '',
      nbViews: map['nbViews'] ?? 0,
    );
  }
}
