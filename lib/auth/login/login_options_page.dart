// Modern & Beautiful LoginOptionsPage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/auth/auth_service.dart';
import 'package:stream24news/auth/create_account/select_cuntory.dart';
import 'package:stream24news/auth/login/login_page.dart';
import '../../utils/componants/bottom_navbar.dart';
import '../../utils/services/shared_pref_service.dart';
import '../create_account/create_account.dart';

class LoginOptionsPage extends StatefulWidget {
  const LoginOptionsPage({super.key});

  @override
  State<LoginOptionsPage> createState() => _LoginOptionsPage();
}

class _LoginOptionsPage extends State<LoginOptionsPage> {
  @override
  Widget build(BuildContext context) {
    List<String> selectedCountry = SharedPrefService().getCounty() ?? [];
    List<String> selectedLanguage = SharedPrefService().getLanguage() ?? [];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: OutlinedButton(
                  onPressed: () {
                    if (selectedLanguage.isEmpty || selectedCountry.isEmpty) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SelectCuntory(commingFrom: 'login'),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavbar()),
                      );
                    }
                  },
                  child: Text(
                    "Skip",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "lib/assets/images/login.png",
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Let's you in",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 30),
                      // Login options
                      GestureDetector(
                        onTap: handleGoogleSignIn,
                        child: loginOption("lib/assets/images/google_login.png",
                            "Continue with Google"),
                      ),
                      const SizedBox(height: 20),
                      // OR Divider
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(thickness: 1, endIndent: 10),
                          ),
                          Text(
                            "OR",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Expanded(
                            child: Divider(thickness: 1, indent: 10),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            "Sign in with password",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Signup section fixed at the bottom
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateAccount()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: const TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginOption(String icon, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          Image.asset(icon, height: 24),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void handleGoogleSignIn() async {
    List<String>? region = SharedPrefService().getCounty() ?? [];

    EasyLoading.show(status: 'Logging...');
    try {
      UserCredential? userCredential = await AuthService().loginWithGoogle();
      if (userCredential != null) {
        if (region.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavbar()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SelectCuntory()),
          );
        }
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Google Sign-In failed. Please try again.")),
      );
    }
  }
}
