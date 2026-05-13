import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../navigation/AppRoutes.dart';
import '../models/utiles/shared_pref.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool hidePass = true;
  String? loginError;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> onLogin() async {
    if (!formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passController.text;

    try {
      // Firebase login
      await authService.value.signIn(
        email: email,
        password: password,
      );

      // Save session locally (your existing SharedPref logic)
      await AuthPrefs.setLoggedInUser(
        email: email,
        username: authService.value.currentUser?.displayName,
      );

      if (!mounted) return;

      setState(() {
        loginError = null;
      });

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      switch (e.code) {
        case 'user-not-found':
          message = "No account found for this email";
          break;
        case 'wrong-password':
          message = "Incorrect password";
          break;
        case 'invalid-email':
          message = "Invalid email address";
          break;
        case 'user-disabled':
          message = "This account has been disabled";
          break;
        case 'network-request-failed':
          message = "No internet connection";
          break;
      }

      if (!mounted) return;

      setState(() {
        loginError = message;
      });

      formKey.currentState!.validate();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loginError = e.toString();
      });

      formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color(0xFF12151c),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9aa4b2),),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
            style: TextStyle(color: Color(0xFF8e3b46), fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight(800)),
            "Log In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Color(0xFFc89b3c),
                decoration: const InputDecoration(
                  labelText: "Email",
                  floatingLabelStyle: TextStyle(color: Color(0xFFc89b3c)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFc89b3c), width: 2),
                  ),
                ),
                validator: (v) {
                  final value = v?.trim() ?? "";
                  if (value.isEmpty) return "Email is required";
                  if (!value.contains("@")) return "Enter a valid email";
                  if (loginError != null) {
                    return loginError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: passController,
                obscureText: hidePass,
                cursorColor: Color(0xFFc89b3c),
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Must be 6+ chars",
                  floatingLabelStyle: TextStyle(color: Color(0xFFc89b3c)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFc89b3c), width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(hidePass ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => hidePass = !hidePass),
                  ),
                ),
                validator: (v) {
                  final value = v ?? "";
                  if (value.isEmpty) return "Password is required";
                  if (value.length < 6) return "Password must be 6+ chars";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFc89b3c), foregroundColor: Colors.white),
                  onPressed: onLogin,
                  child: const Text("Log In"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}