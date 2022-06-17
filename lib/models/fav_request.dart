import 'dart:convert';

class FavRequest {
  int post_id;
  FavRequest({
    required this.post_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'post_id': post_id,
    };
  }

  factory FavRequest.fromJson(Map<String, dynamic> map) {
    return FavRequest(
      post_id: map['post_id']?.toInt() ?? 0,
    );
  }
}
