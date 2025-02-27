import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

class LoginSuccessDialog extends StatelessWidget {
  final String title;
  final String desc;
  const LoginSuccessDialog(
      {super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Lottie.asset("lib/assets/lottie_json/success.json",
              height: 140, repeat: false),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          sizedBoxH20(context),
          Text(
            desc,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
