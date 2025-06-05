import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/auth/auth_service.dart';
import '../../utils/componants/login_success_dialog.dart';
import '../../utils/componants/my_widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  void _resetPassword() async {
    EasyLoading.show(status: 'Logging...');
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "We sent a link to reset your password, Please check your registered email's inbox or spam folder if not receive mail.")),
      );
      EasyLoading.dismiss();
      return;
    }

    try {
      await AuthService().sendPasswordResetEmail(email);
      EasyLoading.dismiss();
      showCustomDialog();
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "No account found with this email.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email format. Please check again.";
      } else {
        errorMessage = "Something went wrong. Try again later.";
      }
      EasyLoading.dismiss();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      EasyLoading.dismiss();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred.")),
      );
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "Enter your email",
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.07,
                child: PrimaryButton(
                  textWidget: const Text(
                    "Send link",
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: _resetPassword,
                ),
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
      ),
    );
  }
}
