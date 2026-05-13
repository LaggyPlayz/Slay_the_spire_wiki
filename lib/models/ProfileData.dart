import 'package:firebase_auth/firebase_auth.dart';
import '../models/utiles/shared_pref.dart';

class ProfileData {
  final String email;
  final String username;

  ProfileData({required this.email, required this.username});
}

Future<ProfileData> loadProfileData() async {
  final user = FirebaseAuth.instance.currentUser;

  // ✅ If Firebase is available (online + logged in)
  if (user != null) {
    return ProfileData(
      email: user.email ?? "No email",
      username: user.displayName ?? "No username",
    );
  }

  // ❌ Offline fallback (SharedPreferences)
  final email = await AuthPrefs.getLoggedInUser() ?? "No email";
  final username = await AuthPrefs.getUsername() ?? "No username";

  return ProfileData(
    email: email,
    username: username,
  );
}