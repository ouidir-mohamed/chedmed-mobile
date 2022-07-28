import 'package:floor/floor.dart';

@entity
class SearchHistory {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int categoryId;
  final int? underCategoryId;
  final String searchDate;
  String lastVisitedDate;

  final int location_id;
  final double latitude;
  final double longitude;

  SearchHistory(this.id, this.searchDate, this.lastVisitedDate, this.categoryId,
      this.underCategoryId, this.location_id, this.latitude, this.longitude);
}
