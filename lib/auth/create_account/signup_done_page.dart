import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../utils/componants/bottom_navbar.dart';

class SignupDonePage extends StatelessWidget {
  const SignupDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("lib/assets/lottie_json/success.json",
                    repeat: false, height: 220),
                sizedBoxH30(context),
                Text(
                  "You\'re All Set!",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                sizedBoxH10(context),
                Text(
                  textAlign: TextAlign.center,
                  "Start exploring, discovering, and engagingwith the news.\nAlways stay updated!",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: PrimaryButton(
                      textWidget: Text(
                        "Let\'s Go",
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomNavbar()));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
