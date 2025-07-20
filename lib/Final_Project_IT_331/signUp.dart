import 'package:flutter/material.dart';
import 'mainLogin.dart';
import 'colors.dart';

// === SignUpPage ===
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String age = '';
  String emailOrPhone = '';
  String password = '';

  // Regular expressions for validation
  final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  final RegExp phoneRegex = RegExp(r"^(09|\+639)\d{9}$");
  final RegExp nameRegex = RegExp(r'^[a-zA-Z]+$');

  void submit() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();

    // Check if password is same as email or contact
    if (password.trim() == emailOrPhone.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Password cannot be the same as your email or contact.")),
      );
      return;
    }

    // Check uniqueness of email or phone
    final exists = registeredUsers
        .any((user) => user.emailOrContact == emailOrPhone.trim());
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email or phone already registered!")),
      );
      return;
    }

    final fullName = "${firstName.trim()} ${lastName.trim()}";

    final newUser = UserAccount(
      emailOrContact: emailOrPhone.trim(),
      password: password.trim(),
      username: fullName,
      recoveryEmail: '',
    );

    registeredUsers.add(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign up successful! Please log in.')),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: teaMaxBrown,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('Tea_Max_Logo.jpg'),
            ),
            SizedBox(width: 10),
            Text("Tea Max"),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F5DC),
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(24),
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
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  "Create Your Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (input) {
                    if (input == null || input.isEmpty) return 'Required';
                    if (!nameRegex.hasMatch(input)) {
                      return 'Only letters allowed';
                    }
                    return null;
                  },
                  onSaved: (val) => firstName = val!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (input) {
                    if (input == null || input.isEmpty) return 'Required';
                    if (!nameRegex.hasMatch(input)) {
                      return 'Only letters allowed';
                    }
                    return null;
                  },
                  onSaved: (val) => lastName = val!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  validator: (input) {
                    if (input == null || input.isEmpty) return 'Required';
                    final parsedAge = int.tryParse(input);
                    if (parsedAge == null) {
                      return 'Enter a valid number';
                    }
                    if (parsedAge > 100) {
                      return 'Age must not exceed 100';
                    }
                    return null;
                  },
                  onSaved: (val) => age = val!,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Email or Phone'),
                  validator: (input) {
                    if (input == null || input.isEmpty) return 'Required';
                    final trimmed = input.trim();
                    if (!emailRegex.hasMatch(trimmed) &&
                        !phoneRegex.hasMatch(trimmed)) {
                      return 'Enter a valid email or PH number';
                    }
                    return null;
                  },
                  onSaved: (val) => emailOrPhone = val!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (input) =>
                      input == null || input.isEmpty ? 'Required' : null,
                  onSaved: (val) => password = val!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submit,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
