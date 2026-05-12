import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> onLogIn() async {
    if (!formKey.currentState!.validate()) return;
    final email = emailController.text.trim();
    final pass = passController.text;
    final user = await AuthPrefs.getUser();
    if (email == user['email'] && pass == user['password']) {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log In"),
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
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = v?.trim() ?? "";
                  if (value.isEmpty) return "Email is required";
                  if (!value.contains("@")) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: passController,
                obscureText: hidePass,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Must be 6+ chars",
                  border: const OutlineInputBorder(),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                  onPressed: onLogIn,
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