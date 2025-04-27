import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

class Samplepage extends StatelessWidget {
  const Samplepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            PrimaryButton(textWidget: const Text("Follow"), onPressed: () {}),
            SecondaryButton(textWidget: const Text("Follow"), onPressed: () {}),
            TersoryButton(textWidget: const Text("Follow"), onPressed: () {}),
            Icon(
              MyTabIcons.home_button_fill,
              color: Theme.of(context).colorScheme.primary,
            ),
            /*
            Container(
              margin: const EdgeInsets.all(10),
              width: 500,
              height: 200,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  "This is a conytainer.",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            Text(
              "This is a container.",
              style: GoogleFonts.dancingScript(fontWeight: FontWeight.bold),
            ),
            Lottie.asset("lib/assets/lottie_json/darkmode.json"),
            Lottie.asset("lib/assets/lottie_json/livetv.json"),
            Lottie.asset("lib/assets/lottie_json/news.json"),
            Lottie.asset("lib/assets/lottie_json/personalized.json"),
            Lottie.asset("lib/assets/lottie_json/scrollphone.json"),
            Lottie.asset("lib/assets/lottie_json/test.json"),
            Lottie.asset("lib/assets/lottie_json/test1.json"),
            */

            sizedBoxH30(context),
            ElevatedButton(
                onPressed: () {
                  test();
                },
                child: Text("Test Api")),
          ]),
        ),
      ),
    );
  }
}

test() async {
  String email = "anilyadav44x@gmail.com";
  final signInMethods =
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  // log("Sign-in methods found: $signInMethods");
}
