import 'dart:convert';

class NotificationsRequest {
  final int page;
  final List<RequestItem> items;
  final String username;
  NotificationsRequest({
    required this.page,
    required this.items,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'username': username,
      'items': items.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'NotificationsRequest(page: $page, items: $items, username: $username)';
}

class RequestItem {
  final int category;
  final int? underCategory;
  final String searchDate;
  final String? lastVisitedDate;
  final Point point;
  RequestItem({
    required this.category,
    this.underCategory,
    required this.searchDate,
    this.lastVisitedDate,
    required this.point,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'underCategory': underCategory,
      'searchDate': searchDate,
      'lastVisitedDate': lastVisitedDate,
      'point': point.toJson(),
    };
  }

  @override
  String toString() {
    return 'RequestItem(category: $category, underCategory: $underCategory, searchDate: $searchDate, lastVisitedDate: $lastVisitedDate, point: $point)';
  }
}

class Point {
  final double lat;
  final double long;
  final int id;
  Point({
    required this.lat,
    required this.long,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'long': long,
      'id': id,
    };
  }

  @override
  String toString() => 'Point(lat: $lat, long: $long, id: $id)';
}
