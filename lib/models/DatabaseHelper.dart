import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/Item.dart';
import './utiles/shared_pref.dart';

class DatabaseHelper {
  static final ValueNotifier<int> updateSignal = ValueNotifier<int>(0);

  static void triggerUpdate() {
    updateSignal.value++;
  }

  static Future<Database> openMyDatabase() async {
    String path = join(await getDatabasesPath(), 'news_db.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE favorites('
                'rowId INTEGER PRIMARY KEY AUTOINCREMENT, '
                'itemId INTEGER, '
                'title TEXT, '
                'imagePath TEXT, '
                'userEmail TEXT)'
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE favorites ADD COLUMN userEmail TEXT'
          );
        }
      },
    );
  }

  // CREATE: Add news
  static Future<void> insertCard(Item item) async {
    final db = await openMyDatabase();
    final email = await AuthPrefs.getUser();

    await db.insert('favorites', {
      'itemId': item.id,
      'title': item.title,
      'imagePath': item.imagePath,
      'userEmail': email['email'],
    });

    triggerUpdate();
  }

  static Future<void> deleteCard(int id) async {
    final db = await openMyDatabase();
    final email = await AuthPrefs.getUser();

    await db.delete(
      'favorites',
      where: 'itemId = ? AND userEmail = ?',
      whereArgs: [id, email['email']],
    );

    triggerUpdate();
  }

  // READ: Get news
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await openMyDatabase();
    final email = await AuthPrefs.getUser();

    return db.query(
      'favorites',
      where: 'userEmail = ?',
      whereArgs: [email['email']],
    );
  }
}