import 'package:chedmed/models/search_history.dart';
import 'package:floor/floor.dart';

import 'database.dart';

@dao
abstract class SahelDao {
  @Query('SELECT * FROM SearchHistory ORDER BY id DESC LIMIT 10')
  Future<List<SearchHistory>> getAllHistory();

  @insert
  Future<void> addToHistory(SearchHistory searchHistory);

  @Query('DELETE  FROM SearchHistory WHERE id < :lastValideId')
  Future<void> deleteOldHistoryItems(int lastValideId);

  @Query('UPDATE SearchHistory SET lastVisitedDate = :lastVisitedDate WHERE 1')
  Future<void> updateLastVisitedDate(String lastVisitedDate);
}

late SahelDao sahelDao;
initDatabaseInstance() async {
  final database = await $FloorAppDatabase.databaseBuilder('yadb.db').build();
  sahelDao = database.sahelDao;
}
