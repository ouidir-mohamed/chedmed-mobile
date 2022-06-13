class FavoriteRequest {
  List<int> postIds;
  FavoriteRequest({
    required this.postIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'postIds': postIds,
    };
  }

  factory FavoriteRequest.fromJson(Map<String, dynamic> map) {
    return FavoriteRequest(
      postIds: List<int>.from(map['postIds']),
    );
  }
}
