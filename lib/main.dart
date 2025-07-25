import 'package:flutter/material.dart';
import 'dart:io';
import 'home.dart';
import 'signUp.dart';
import 'colors.dart';

void main() => runApp(const MyApp());

// === Storage for user details ===
class UserAccount {
  String emailOrContact;
  String password;
  String username;
  String recoveryEmail;
  File? profilePicture;

  UserAccount({
    required this.emailOrContact,
    required this.password,
    required this.username,
    required this.recoveryEmail,
    this.profilePicture,
  });
}

List<UserAccount> registeredUsers = [];
UserAccount? currentUser;

// === Main App ===
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tea Max App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'EBGaramond-Medium',
        appBarTheme: const AppBarTheme(
          backgroundColor: teaMaxBrown,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: teaMaxBrown,
            foregroundColor: Colors.white,
          ),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.brown),
          bodyMedium:
              TextStyle(color: Colors.brown, fontFamily: 'EBGaramond-Medium'),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

// === Login Page ===
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String input = '';
  String password = '';
  String emailError = '';
  String passwordError = '';
  String errorMessage = '';

  void submit() {
    setState(() {
      emailError = '';
      passwordError = '';
    });

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    formKey.currentState?.save();

    final user = registeredUsers.firstWhere(
      (u) => u.emailOrContact == input.trim(),
      orElse: () => UserAccount(
        emailOrContact: '',
        password: '',
        username: '',
        recoveryEmail: '',
      ),
    );

    if (user.emailOrContact.isEmpty) {
      setState(() => emailError = "Account does not exist");
      return;
    }

    if (user.password != password.trim()) {
      setState(() => passwordError = "Incorrect password");
      return;
    }

    currentUser = user;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        backgroundColor: teaMaxBrown,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/Tea_Max_Logo.png'),
            ),
            SizedBox(width: 10),
            Text("Tea Max"),
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Login to Your Account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email or Contact',
                    errorText: emailError.isNotEmpty ? emailError : null,
                  ),
                  validator: (value) {
                    final emailRegex =
                        RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                    final phoneRegex = RegExp(r"^(09|\+639)\d{9}$");

                    if (value == null || value.isEmpty) return 'Required';
                    if (!emailRegex.hasMatch(value.trim()) &&
                        !phoneRegex.hasMatch(value.trim())) {
                      return 'Invalid account';
                    }
                    return null;
                  },
                  onSaved: (val) => input = val ?? '',
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: passwordError.isNotEmpty ? passwordError : null,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 8) return 'Minimum of 8 characters';
                    return null;
                  },
                  onSaved: (val) => password = val ?? '',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submit,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  child: const Text("Login"),
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpPage()),
                    );
                  },
                  child: const Text("Don't have an account? Sign up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
