import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset("lib/assets/images/login.png")),
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
              loginOption(
                  "lib/assets/images/google_login.png", "Continue with Google"),
              loginOption("lib/assets/images/facebook_login.png",
                  "Continue with Facebook"),
              loginOption(
                  "lib/assets/images/apple_login.png", "Continue with Apple"),
              loginOption("lib/assets/images/x_login.png",
                  "Continue with  X (Twitter)"),
              sizedBoxH30(context),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: PrimaryButton(
                      text: "Sign in with password", onPressed: () {}))
            ],
          ),
        ),
      ),
    );
  }

  Widget loginOption(String icon, String title) {
    return Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black12)),
        child: Center(
          child: ListTile(
            leading: Image.asset(icon, scale: 2),
            title: Text(title),
          ),
        ));
  }
}
