import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/auth/auth_service.dart';
import 'package:stream24news/auth/create_account/select_cuntory.dart';
import 'package:stream24news/auth/login/login_page.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
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
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Stack(children: [
            Positioned(
                right: 0,
                top: 0,
                child: SecondaryButton(
                    textWidget: Text("Skip"), onPressed: () {})),
            SingleChildScrollView(
              child: Column(
                children: [
                  sizedBoxH10(context),
                  GestureDetector(
                    onTap: () {
                      //shared preferences for storing skipped value is on sign_up_done_page
                      if (selectedLanguage.isEmpty || selectedCountry.isEmpty) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SelectCuntory(
                                      commingFrom: 'login',
                                    )));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavbar()));
                      }
                    },
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.24,
                        child: Image.asset("lib/assets/images/login.png")),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.03,
                    ),
                    child: Text(
                      "Let's you in",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      handleGoogleSignIn();
                    },
                    child: loginOption("lib/assets/images/google_login.png",
                        "Continue with Google"),
                  ),
                  loginOption("lib/assets/images/apple_login.png",
                      "Continue with Apple"),
                  loginOption("lib/assets/images/facebook_login.png",
                      "Continue with Facebook"),
                  loginOption("lib/assets/images/x_login.png",
                      "Continue with  X (Twitter)"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.07,
                    child: PrimaryButton(
                        textWidget: const Text(
                          "Sign in with password",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        }),
                  ),
                  sizedBoxH20(context),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateAccount()));
                    },
                    child: const Text.rich(TextSpan(
                        text: 'Don\'t have an account?  ',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Sign up',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ])),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget loginOption(String icon, String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.010),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Theme.of(context).colorScheme.shadow),
      ),
      child: Center(
        child: ListTile(
          leading: icon == "lib/assets/images/x_login.png" && isDarkMode
              ? ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    -1, 0, 0, 0, 255, // Invert Red
                    0, -1, 0, 0, 255, // Invert Green
                    0, 0, -1, 0, 255, // Invert Blue
                    0, 0, 0, 1, 0, // Preserve Alpha
                  ]),
                  child: Image.asset(icon, scale: 2.6),
                )
              : icon == "lib/assets/images/apple_login.png" && isDarkMode
                  ? ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Image.asset(icon, scale: 2.6),
                    )
                  : Image.asset(icon, scale: 2.6),
          title: Text(
            title,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  void handleGoogleSignIn() async {
    EasyLoading.show(status: 'Logging...');
    try {
      UserCredential? userCredential = await AuthService().loginWithGoogle();

      if (userCredential != null) {
        User? user = userCredential.user;
        log("Google Sign-In Successful: ${user?.displayName}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
      } else {
        // log("Google Sign-In canceled by user.");
      }
      EasyLoading.dismiss();
    } catch (e) {
      log("Error during Google Sign-In: $e");
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Google Sign-In failed. Please try again.")),
      );
    }
  }
}
