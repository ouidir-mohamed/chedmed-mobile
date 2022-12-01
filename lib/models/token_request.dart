import 'dart:convert';

class TokenRequest {
  String token;
  TokenRequest({
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
