import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream24news/auth/login/login_page.dart';

import '../../auth/auth_service.dart';
import '../../auth/login/login_options_page.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = getUser();
  }

  User? getUser() {
    if (AuthService().isUserLoggedIn()) {
      return AuthService().getUser();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal Information"),
        centerTitle: true,
        elevation: 0,
      ),
      body: user == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "You're not logged in",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Please login to view your personal information.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginOptionsPage()),
                        );
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("Login"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user!.photoURL != null
                        ? CachedNetworkImageProvider(user!.photoURL!)
                        : null,
                    child: user!.photoURL == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user!.displayName ?? "No Name",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user!.email ?? "No Email",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  _infoTile("UID", user!.uid),
                  _infoTile(
                      "Email Verified", user!.emailVerified ? "Yes" : "No"),
                  if (user!.phoneNumber != null)
                    _infoTile("Phone", user!.phoneNumber!),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await AuthService().signOut();
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Log Out"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
