import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/utiles/shared_pref.dart';
import '../models/ProfileData.dart';
import '../navigation/AppRoutes.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<ProfileData> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = loadProfileData();
  }

  Future<ProfileData> loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return ProfileData(
        email: user.email ?? "email@email.com",
        username: user.displayName ?? "Username",
      );
    }

    final email = await AuthPrefs.getLoggedInUser() ?? "email@email.com";
    final username = await AuthPrefs.getUsername() ?? "Username";

    return ProfileData(
      email: email,
      username: username,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12151c),

      appBar: AppBar(
        backgroundColor: const Color(0xFF12151c),
        title: const Text(
          "Profile",
          style: TextStyle(color: Color(0xFFe6e0d4)),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF8e3b46)),
      ),

      body: FutureBuilder<ProfileData>(
        future: profileFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // USER INFO SECTION
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1b2230),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF8e3b46),
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.email,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _ProfileButton(
                  icon: Icons.edit,
                  text: "Update Username",
                  onTap: () {},
                ),

                _ProfileButton(
                  icon: Icons.lock_reset,
                  text: "Reset Password",
                  onTap: () {},
                ),

                _ProfileButton(
                  icon: Icons.password,
                  text: "Change Password",
                  onTap: () {},
                ),

                _ProfileButton(
                  icon: Icons.logout,
                  text: "Sign Out",
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    await AuthPrefs.logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.signup,
                          (route) => false,
                    );
                  },
                ),

                _ProfileButton(
                  icon: Icons.delete_forever,
                  text: "Delete Account",
                  danger: true,
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool danger;

  const _ProfileButton({
    required this.icon,
    required this.text,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1b2230),
      child: ListTile(
        leading: Icon(icon, color: danger ? Colors.red : Colors.white),
        title: Text(
          text,
          style: TextStyle(
            color: danger ? Colors.red : Colors.white,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
