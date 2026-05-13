import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../navigation/AppRoutes.dart';
import '../models/utiles/shared_pref.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  bool hidePass = true;
  bool hideConfirm = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> onSignup() async {
    if (!formKey.currentState!.validate()) return;

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passController.text.trim();

    try {
      // Create Firebase account
      await authService.value.createAccount(
        email: email,
        password: password,
      );

      // Update display name
      await authService.value.updateUsername(
        username: username,
      );

      // Optional local session
      await AuthPrefs.setLoggedInUser(
        email: email,
        username: authService.value.currentUser?.displayName,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully"),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";

      switch (e.code) {
        case 'email-already-in-use':
          message = "Email already in use";
          break;

        case 'invalid-email':
          message = "Invalid email address";
          break;

        case 'weak-password':
          message = "Password is too weak";
          break;

        case 'network-request-failed':
          message = "No internet connection";
          break;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void skipToLogIn() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xFF12151c),
        title: Text(
            style: TextStyle(color: Color(0xFF8e3b46), fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight(800)),
            "Sign Up"),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: usernameController,
                cursorColor: Color(0xFFc89b3c),
                decoration: const InputDecoration(
                  labelText: "Username",
                  floatingLabelStyle: TextStyle(color: Color(0xFFc89b3c)),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFc89b3c), width: 2),
                  ),
                ),
                validator: (v) {
                  final value = v?.trim() ?? "";
                  if (value.isEmpty) return "Username is required";
                  if (value.length < 3) return "Username must be 3+ chars";
                  return null;
                },
              ),
              const SizedBox(height: 12),

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

                  if (value.isEmpty) {
                    return "Email is required";
                  }

                  if (!value.contains("@")) {
                    return "Enter a valid email";
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
                  floatingLabelStyle: const TextStyle(color: Color(0xFFc89b3c)),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
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
              const SizedBox(height: 12),

              TextFormField(
                controller: confirmController,
                obscureText: hideConfirm,
                cursorColor: Color(0xFFc89b3c),
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  floatingLabelStyle: const TextStyle(color: Color(0xFFc89b3c)),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFc89b3c), width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(hideConfirm ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => hideConfirm = !hideConfirm),
                  ),
                ),
                validator: (v) {
                  final value = v ?? "";
                  if (value.isEmpty) return "Confirm password is required";
                  if (value != passController.text) return "Passwords do not match";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFc89b3c), foregroundColor: Colors.white),
                  onPressed: onSignup,
                  child: const Text("Create Account"),
                ),
              ),
              const SizedBox(height: 2),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('or'),
                ],
              ),
              const SizedBox(height: 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: skipToLogIn,
                  child: const Text("Log In",
                    style: TextStyle(
                      color: Color(0xFFc89b3c),
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}