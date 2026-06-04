import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/beer_record.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bison_comptoir.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE beers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp INTEGER NOT NULL,
        volume INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertBeer(BeerRecord beer) async {
    Database db = await database;
    return await db.insert('beers', beer.toMap());
  }

  Future<List<BeerRecord>> getAllBeers() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('beers', orderBy: 'timestamp ASC');
    return List.generate(maps.length, (i) {
      return BeerRecord.fromMap(maps[i]);
    });
  }

  Future<List<BeerRecord>> getTodayBeers() async {
    Database db = await database;
    final int startOfDay = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0).millisecondsSinceEpoch;
    final List<Map<String, dynamic>> maps = await db.query(
      'beers',
      where: 'timestamp >= ?',
      whereArgs: [startOfDay],
      orderBy: 'timestamp ASC',
    );
    return List.generate(maps.length, (i) {
      return BeerRecord.fromMap(maps[i]);
    });
  }

  Future<void> deleteTodayBeers() async {
    Database db = await database;
    final int startOfDay = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0).millisecondsSinceEpoch;
    await db.delete(
      'beers',
      where: 'timestamp >= ?',
      whereArgs: [startOfDay],
    );
  }
}
