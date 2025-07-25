import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'drawer.dart';
import 'main.dart';
import 'colors.dart';

// === Profile Page ===
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController recoveryController;
  File? newProfilePicture;

  Uint8List? image;

  @override
  void initState() {
    super.initState();
    usernameController =
        TextEditingController(text: currentUser?.username ?? '');
    recoveryController =
        TextEditingController(text: currentUser?.recoveryEmail ?? '');
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    } else {
      const Text('No Image Selected');
    }
  }

  void selectImage() async {
    Uint8List ing = await pickImage(ImageSource.gallery);
    setState(() {
      image = ing;
    });
  }

  void updateProfile() {
    if (formKey.currentState!.validate()) {
      setState(() {
        currentUser?.username = usernameController.text.trim();
        currentUser?.recoveryEmail = recoveryController.text.trim();
        if (newProfilePicture != null) {
          currentUser?.profilePicture = newProfilePicture;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    }
  }

  /* */

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'Are you sure you want to permanently delete your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              registeredUsers.removeWhere(
                  (u) => u.emailOrContact == currentUser?.emailOrContact);
              currentUser = null;
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Delete',
                style: TextStyle(color: Color.fromARGB(255, 146, 52, 5))),
          ),
        ],
      ),
    );
  }

  String? validateRecovery(String? value) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    final phoneRegex = RegExp(r"^(09|\+639)\d{9}$");

    if (value == null || value.isEmpty) return 'Required';
    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return 'Enter valid email or contact number';
    } else if (value == currentUser?.emailOrContact) {
      return 'Account already in use, use a different one.';
    }
    return null;
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
              backgroundImage: AssetImage('assets/Tea_Max_Logo.png'),
            ),
            SizedBox(width: 10),
            Text("Tea Max"),
          ],
        ),
      ),
      drawer: const DrawerMenu(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: MemoryImage(image!),
                        )
                      : GestureDetector(
                          onTap: selectImage,
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSE26NjQaonqTRt7BXD_87Iuukitk_kcGBv3w&s'),
                          ),
                        ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: const CircleAvatar(
                        backgroundColor: Colors.brown,
                        radius: 16,
                        child: Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 9),
                    TextFormField(
                      controller: recoveryController,
                      decoration: const InputDecoration(
                          labelText: 'Recovery Email or Contact'),
                      validator: validateRecovery,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: const Text('Update Profile'),
                    ),
                    const SizedBox(height: 9),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: confirmDelete,
                      child: const Text('Delete Account'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
