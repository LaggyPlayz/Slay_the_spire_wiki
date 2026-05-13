import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/utiles/shared_pref.dart';
import './home.dart';
import 'signup.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<bool> _isLoggedInOffline() async {
    final email = await AuthPrefs.getLoggedInUser();
    return email != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasInternet(),
      builder: (context, internetSnapshot) {
        if (internetSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final hasInternet = internetSnapshot.data ?? false;

        // 🌐 ONLINE → Firebase is truth
        if (hasInternet) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final user = snapshot.data;

              if (user != null) {
                return const HomePage();
              } else {
                return const SignupScreen();
              }
            },
          );
        }

        // 📴 OFFLINE → fallback to SharedPreferences
        return FutureBuilder<bool>(
          future: _isLoggedInOffline(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final loggedInOffline = snapshot.data ?? false;

            if (loggedInOffline) {
              return const HomePage();
            } else {
              return const SignupScreen();
            }
          },
        );
      },
    );
  }
}