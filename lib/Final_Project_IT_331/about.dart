import 'package:flutter/material.dart';
import 'drawer.dart';
import 'colors.dart';

// === About Page ===
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
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
        drawer: const DrawerMenu(),
        body: const SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('Tea_Max_Logo.jpg'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tea Max Connect',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Coffee and tea are part of many people\'s daily lives. We drink them to wake up, relax, or lift our mood while working or studying. But sometimes, ordering in a coffee shop takes too long, and there are only a few ways to pay. That\'s why it\'s better to have an app that makes ordering easier and faster.\n\nSince many people prefer using their phones for a faster and more complete service, the team decided to create Teamax, a mobile app for a coffee shop. It is used as a digital system for ordering and payment. \n\nIn this app, users can check the menu for coffee and tea, place their order, and choose to pay using GCash or cash. After a successful purchase, the app sends a notification with a Wi-Fi code. This code gives the customer free Wi-Fi inside the shop for a limited time.\n\nThe app was developed using Flutter, a tool for creating mobile applications. With Teamax, the goal is to make ordering drinks easier, faster, and more convenient for all customers.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Text(
                    '\nDeveloped by:\nTea Max\nIT 331 - Application Development\nBatangas State University - Alangilan',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
