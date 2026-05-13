import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase _firebaseDatabase =
  FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
    "https://slay-the-spire-wiki-e9f46-default-rtdb.europe-west1.firebasedatabase.app/",
  );

  // Create
  Future<void> create({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    await ref.set(data);
  }

  // Read
  Future<DataSnapshot?> read({
    required String path,
  }) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    final DataSnapshot snapshot = await ref.get();
    return snapshot.exists ? snapshot : null;
  }

  // Update
  Future<void> update({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    await ref.update(data);
  }

  // Delete
  Future<void> delete({
    required String path,
  }) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    await ref.remove();
  }

  Future<void> toggleFavorite({
    required String userId,
    required int itemId,
    required bool isFavorite,
  }) async {
    final ref = _firebaseDatabase
        .ref()
        .child("favorites")
        .child(userId)
        .child(itemId.toString());

    if (isFavorite) {
      await ref.set(true);
    } else {
      await ref.remove();
    }
  }
}