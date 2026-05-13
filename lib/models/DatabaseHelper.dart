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
        await db.execute(
            'CREATE TABLE users('
                'email TEXT PRIMARY KEY, '
                'username TEXT, '
                'password TEXT)'
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

  static Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    final db = await openMyDatabase();

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty;
  }

  static Future<bool> emailExists(String email) async {
    final db = await openMyDatabase();

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  static Future<void> insertUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final db = await openMyDatabase();

    await db.insert(
      'users',
      {
        'username': username,
        'email': email,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // CREATE: Add news
  static Future<void> insertCard(Item item) async {
    final db = await openMyDatabase();
    final email = await AuthPrefs.getLoggedInUser();

    await db.insert('favorites', {
      'itemId': item.id,
      'title': item.title,
      'imagePath': item.imagePath,
      'userEmail': email,
    });
  }

  static Future<void> deleteCard(int id) async {
    final db = await openMyDatabase();
    final email = await AuthPrefs.getLoggedInUser();

    await db.delete(
      'favorites',
      where: 'itemId = ? AND userEmail = ?',
      whereArgs: [id, email],
    );
  }

  // READ: Get news
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await openMyDatabase();
    final email = await AuthPrefs.getLoggedInUser();

    return db.query(
      'favorites',
      where: 'userEmail = ?',
      whereArgs: [email],
    );
  }
}