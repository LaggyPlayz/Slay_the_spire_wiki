import 'package:firebase_auth/firebase_auth.dart';
import '../../services/database_service.dart';

class FavoritesService {
  final DatabaseService _db = DatabaseService();

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  String _path(String itemId) {
    final uid = _uid;
    if (uid == null) throw Exception("User not logged in");
    return "users/$uid/favorites/$itemId";
  }

  // ADD favorite
  Future<void> addFavorite(int itemId) async {
    await _db.create(
      path: _path(itemId.toString()),
      data: {"value": true},
    );
  }

  // REMOVE favorite
  Future<void> removeFavorite(int itemId) async {
    await _db.delete(
      path: _path(itemId.toString()),
    );
  }

  // CHECK single favorite
  Future<bool> isFavorite(int itemId) async {
    final snapshot = await _db.read(
      path: _path(itemId.toString()),
    );

    return snapshot != null && snapshot.value != null;
  }

  // GET all favorites
  Future<List<int>> getFavorites() async {
    final uid = _uid;
    if (uid == null) return [];

    final snapshot = await _db.read(path: "users/$uid/favorites");

    if (snapshot == null || snapshot.value == null) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.keys.map((e) => int.parse(e)).toList();
  }
}