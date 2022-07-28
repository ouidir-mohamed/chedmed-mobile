import 'dart:async';

import 'package:chedmed/ressources/dao/sahel_dao.dart';
import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import '../../models/search_history.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [SearchHistory])
abstract class AppDatabase extends FloorDatabase {
  SahelDao get sahelDao;
}
