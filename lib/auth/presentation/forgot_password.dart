import 'package:flutter/material.dart';

import '../../utils/componants/my_widgets.dart';
import '../../utils/componants/sizedbox.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Forgot Password 🔑",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                "Please enter your email address. We will send you a password reset link. Kindly check your inbox and reset your password.",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Text("Email", style: Theme.of(context).textTheme.titleSmall),
            TextField(
              keyboardType: TextInputType.emailAddress,
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 70,
              child: PrimaryButton(
                textWidget: const Text(
                  "Send link",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {},
              ),
            ),
            sizedBoxH30(context),
          ],
        ),
      ),
    );
  }
}
