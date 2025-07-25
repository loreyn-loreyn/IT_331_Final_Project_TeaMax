import 'package:flutter/material.dart';
import 'dart:io';

// === Colors ===
const teaMaxBrown = Color.fromARGB(222, 122, 93, 20);

// === User Data Storage ===
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

void main() {
  runApp(const MyApp());
}

// === MyApp Root ===
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tea_max Connect',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const LoginPage(),
    );
  }
}

// === Login Page ===
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorText = '';

  void login() {
    String input = emailController.text.trim();
    String password = passwordController.text;

    final user = registeredUsers.firstWhere(
      (u) => u.emailOrContact == input,
      orElse: () => UserAccount(
          emailOrContact: '', password: '', username: '', recoveryEmail: ''),
    );

    if (user.emailOrContact == '') {
      setState(() {
        errorText = 'Invalid account';
      });
    } else if (user.password != password) {
      setState(() {
        errorText = 'Incorrect password';
      });
    } else {
      setState(() {
        errorText = '';
        currentUser = user;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: 'Email or Contact')),
            const SizedBox(height: 10),
            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password')),
            if (errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    Text(errorText, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()));
              },
              child: const Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// === Sign Up Page ===
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final recoveryController = TextEditingController();
  String errorText = '';

  void signUp() {
    final newUser = UserAccount(
      emailOrContact: emailController.text.trim(),
      password: passwordController.text,
      username: usernameController.text.trim(),
      recoveryEmail: recoveryController.text.trim(),
    );

    if (registeredUsers
        .any((u) => u.emailOrContact == newUser.emailOrContact)) {
      setState(() {
        errorText = 'Account already exists';
      });
      return;
    }

    registeredUsers.add(newUser);
    currentUser = newUser;

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: 'Email or Contact')),
            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password')),
            TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username')),
            TextField(
                controller: recoveryController,
                decoration: const InputDecoration(labelText: 'Recovery Email')),
            if (errorText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    Text(errorText, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: signUp, child: const Text('Create Account')),
          ],
        ),
      ),
    );
  }
}

// === Drawer Menu ===
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: teaMaxBrown),
            child: UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: teaMaxBrown),
              accountName: Text(currentUser?.username ?? "Guest",
                  style: const TextStyle(fontSize: 16)),
              accountEmail: Text(
                  currentUser?.emailOrContact ?? "No contact info",
                  style: const TextStyle(fontSize: 12)),
              currentAccountPictureSize: const Size.square(45),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSE26NjQaonqTRt7BXD_87Iuukitk_kcGBv3w&s'),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Logout(context).logoutDialog(),
          ),
        ],
      ),
    );
  }
}

// === Home Page ===
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('tea_max Home')),
      drawer: const DrawerMenu(),
      body: const Center(child: Text('Welcome to tea_max Connect!')),
    );
  }
}

// === Profile Page ===
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: currentUser == null
            ? const Text('No user logged in.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Username:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(currentUser!.username),
                  const SizedBox(height: 10),
                  const Text('Email/Contact:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(currentUser!.emailOrContact),
                  const SizedBox(height: 10),
                  const Text('Recovery Email:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(currentUser!.recoveryEmail),
                ],
              ),
      ),
    );
  }
}

// === About Page ===
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About tea_max')),
      drawer: const DrawerMenu(),
      body: const Center(
          child: Text('tea_max is a tea ordering and WiFi connection system.')),
    );
  }
}

// === Logout Dialog ===
class Logout {
  final BuildContext context;
  Logout(this.context);

  void logoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              currentUser = null;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
