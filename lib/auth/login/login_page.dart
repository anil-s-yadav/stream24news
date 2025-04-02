import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream24news/auth/login/forgot_password.dart';
import 'package:stream24news/auth/auth_service.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../utils/componants/bottom_navbar.dart';
import '../../utils/componants/login_success_dialog.dart';
import '../../utils/componants/my_widgets.dart';
import '../../utils/services/shared_pref_service.dart';
import '../create_account/create_account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passwordVisibility = true;
  final _myAuth = AuthService();

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
                  validator: validateEmail,
                ),
                sizedBoxH30(context),
                Text("Password", style: Theme.of(context).textTheme.titleSmall),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8) {
                      return 'At least 8 characters long.';
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
    try {
      final user = await _myAuth.loginUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        print("User ID: ${user.uid}");
        print("Name: ${user.displayName}");
        print("Email: ${user.email}");
        print("Phone: ${user.phoneNumber}");
        print("Photo URL: ${user.photoURL}");
        showCustomDialog();
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "User not registered. Please sign up.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Try again.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email format.";
          break;
        case 'invalid-credential':
          errorMessage =
              "Invalid credentials. Please check email and password.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many failed attempts. Try again later.";
          break;
        default:
          errorMessage = "An error occurred. Please try again.";
      }
      _showErrorMessage(errorMessage);
    } catch (e) {
      _showErrorMessage("Something went wrong. Please try again.");
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
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

    // SharedPrefService().setLoginDoneBool(true);

    await Future.delayed(const Duration(seconds: 3));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );
    }
  }
}
