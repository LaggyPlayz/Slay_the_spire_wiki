import 'package:flutter/material.dart';

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

  String savedEmail = "";
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
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await AuthPrefs.getUser();
    setState(() {
      savedEmail = user["email"] ?? "";
    });
  }

  Future<void> onSignup() async {
    if (!formKey.currentState!.validate()) return;
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final pass = passController.text;
    await AuthPrefs.saveUser(username: username, email: email,password: pass);
    Navigator.pushNamed(context, AppRoutes.login);
  }

  void skipToLogIn() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = v?.trim() ?? "";
                  if (value.isEmpty) return "Email is required";
                  if (!value.contains("@")) return "Enter a valid email";
                  if (emailController.text == savedEmail) return "Enter a valid email";
                  return null;
                }
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
              const SizedBox(height: 12),

              TextFormField(
                controller: confirmController,
                obscureText: hideConfirm,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: const OutlineInputBorder(),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
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