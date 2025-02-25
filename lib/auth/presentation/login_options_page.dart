import 'package:flutter/material.dart';
import 'package:stream24news/auth/presentation/login_page.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../utils/componants/bottom_navbar.dart';

class LoginOptionsPage extends StatefulWidget {
  const LoginOptionsPage({super.key});

  @override
  State<LoginOptionsPage> createState() => _LoginOptionsPage();
}

class _LoginOptionsPage extends State<LoginOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavbar()));
                  },
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.27,
                      child: Image.asset("lib/assets/images/login.png")),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Text(
                    "Let's you in",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                loginOption("lib/assets/images/google_login.png",
                    "Continue with Google"),
                loginOption(
                    "lib/assets/images/apple_login.png", "Continue with Apple"),
                loginOption("lib/assets/images/facebook_login.png",
                    "Continue with Facebook"),
                loginOption("lib/assets/images/x_login.png",
                    "Continue with  X (Twitter)"),
                sizedBoxH30(context),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
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
                  onTap: () {},
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
        ),
      ),
    );
  }

  Widget loginOption(String icon, String title) {
    return Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.012),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black12)),
        child: Center(
          child: ListTile(
            leading: Image.asset(icon, scale: 2.3),
            title: Text(title),
          ),
        ));
  }
}
