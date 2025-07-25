import 'package:flutter/material.dart';
import 'home.dart';
import 'about.dart';
import 'profile.dart';
import 'main.dart';
import 'logout.dart';
import 'colors.dart';

// === Drawer ===
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
              accountName: Text(
                currentUser?.username ?? "Guest",
                style: const TextStyle(fontSize: 16),
              ),
              accountEmail: Text(
                currentUser?.emailOrContact ?? "No contact info",
                style: const TextStyle(fontSize: 12),
              ),
              currentAccountPictureSize: const Size.square(45),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSE26NjQaonqTRt7BXD_87Iuukitk_kcGBv3w&s'),
              ),
            ),
          ),

          // === Home Page ===
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),

          // === Profile Page ===
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),

          // === LogOut ===
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
