import 'package:flutter/material.dart';
import 'package:stream24news/auth/presentation/login_options_page.dart';

import '../../utils/componants/login_success_dialog.dart';
import '../../utils/componants/my_widgets.dart';

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
        padding: const EdgeInsets.all(20),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                "Please enter your email address. We will send you a password reset link. Kindly check your inbox and reset your password.",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.shadow, fontSize: 16),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Text("Email", style: Theme.of(context).textTheme.titleSmall),
            const TextField(
              keyboardType: TextInputType.emailAddress,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              child: PrimaryButton(
                textWidget: const Text(
                  "Send link",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  showCustomDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  showCustomDialog() async {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              scrollable: true,
              content: LoginSuccessDialog(
                title: "Mail sent!",
                desc: "Please check your email and reset password.",
              ),
            ));
  }
}
