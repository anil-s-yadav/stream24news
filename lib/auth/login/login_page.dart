import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/auth/login/forgot_password.dart';
import 'package:stream24news/auth/auth_service.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../utils/componants/bottom_navbar.dart';
import '../../utils/componants/login_success_dialog.dart';
import '../../utils/componants/my_widgets.dart';
import '../create_account/create_account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passwordVisibility = true;

  String? validateEmail(String? email) {
    RegExp emailRegEx = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegEx.hasMatch(email ?? "");
    if (!isEmailValid) return "please  Enter a valid email";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures keyboard doesn’t overflow UI
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Welcome back 👋",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text(
                    "Please enter your email and password to sign in",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.shadow,
                        fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
                sizedBoxH30(context),
                Text("Email", style: Theme.of(context).textTheme.titleSmall),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  // validator: validateEmail,
                ),
                sizedBoxH30(context),
                Text("Password", style: Theme.of(context).textTheme.titleSmall),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'At least 6 characters long.';
                    } else if (value.length > 26) {
                      return "Password can't be 25 characters long.";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisibility = !passwordVisibility;
                        });
                      },
                      child: Icon(
                        passwordVisibility
                            ? Icons.visibility_off
                            : Icons.remove_red_eye,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  obscureText: passwordVisibility,
                ),
                sizedBoxH30(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateAccount()));
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateAccount()));
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: 'Don\'t have an account?  ',
                          style: TextStyle(fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                sizedBoxH20(context),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: PrimaryButton(
                      textWidget: const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signIn();
                        }
                      }),
                ),
                sizedBoxH15(context),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgotPassword()));
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(fontSize: 17, color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signIn() async {
    EasyLoading.show(status: 'Logging...');
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    try {
      final user =
          await AuthService().loginUserWithEmailAndPassword(email, password);
      // SharedPrefService().setProfilePhoto(user?.photoURL ??
      //     "https://demofree.sirv.com/nope-not-here.svg?w=150");
      if (user != null) {
        showCustomDialog();
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.code;
      if (e.code == 'user-not-found') {
        errorMessage = 'This email is not register, please signup!';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage =
            "Email or password is incorrect. \nOR\n If you Signup through Google, then please try signing in with Google";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Too many failed attempts. Try again later.";
      }
      EasyLoading.dismiss();
      _showErrorMessage(errorMessage);
    } catch (e) {
      EasyLoading.dismiss();
      _showErrorMessage("An error occurred. Please try again.");
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      message.toString(),
                      textAlign: TextAlign.center,
                    ),
                    sizedBoxH10(context),
                    CloseButton(
                      color: Colors.redAccent,
                    )
                  ],
                ),
              ),
            ));
  }

  Future<void> showCustomDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing before navigation
      builder: (context) => const AlertDialog(
        scrollable: true,
        content: LoginSuccessDialog(
          title: "Sign in successful!",
          desc: "Please wait... \nYou will be directed to the homepage.",
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 3));

    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );
    }
  }
}
