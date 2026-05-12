import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/Item.dart';

class DatabaseHelper {
  static final ValueNotifier<int> updateSignal = ValueNotifier<int>(0);

  static void triggerUpdate() {
    updateSignal.value++;
  }

  static Future<Database> openMyDatabase() async {
    String path = join(await getDatabasesPath(), 'news_db.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE favorites(id INTEGER PRIMARY KEY, title TEXT, imagePath TEXT)'
        );
      },
    );
  }

  // CREATE: Add news
  static Future<void> insertNews(Item news) async {
    final db = await openMyDatabase(); // We call the open function every time
    await db.insert('favorites', news.toMap());
    triggerUpdate();
  }

  static Future<void> deleteNews(int id) async {
    final db = await openMyDatabase();
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    triggerUpdate();
  }

  // READ: Get news
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await openMyDatabase();
    return db.query('favorites');
  }
}