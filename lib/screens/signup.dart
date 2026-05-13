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