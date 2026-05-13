import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  /// Listen to authentication changes
  Stream<User?> get authState => firebaseAuth.authStateChanges();

  /// Current logged in user
  User? get currentUser => firebaseAuth.currentUser;

  /// Sign in
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Create account
  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// Send reset password email
  Future<void> resetPassword({
    required String email,
  }) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Update display name
  Future<void> updateUsername({
    required String username,
  }) async {
    await currentUser?.updateDisplayName(username);

    // Refresh user data
    await currentUser?.reload();
  }

  /// Delete account
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    await user.reauthenticateWithCredential(credential);

    await user.delete();

    await firebaseAuth.signOut();
  }

  /// Change password
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-user',
        message: 'No user is currently signed in.',
      );
    }

    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    await user.updatePassword(newPassword);
  }
}