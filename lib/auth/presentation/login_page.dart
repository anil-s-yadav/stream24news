import 'package:flutter/material.dart';
import 'package:stream24news/auth/presentation/forgot_password.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../utils/componants/login_success_dialog.dart';
import '../../utils/componants/my_widgets.dart';
import '../create_account/create_account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool? checkBoxValue = true;
  bool passwordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures keyboard doesn’t overflow UI
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
              const TextField(
                keyboardType: TextInputType.emailAddress,
              ),
              sizedBoxH30(context),
              Text("Password", style: Theme.of(context).textTheme.titleSmall),
              TextFormField(
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
              sizedBoxH10(context),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Checkbox(
                    value: checkBoxValue,
                    onChanged: (newValue) {
                      setState(() => checkBoxValue = newValue);
                    },
                  ),
                  const Text("I agree to Stream24 News. ",
                      style: TextStyle(fontSize: 12)),
                  const Text("Terms & Policy. ",
                      style: TextStyle(fontSize: 12, color: Colors.blue)),
                ],
              ),
              sizedBoxH30(context),
              const Divider(
                indent: 30,
                endIndent: 30,
                color: Colors.black12,
              ),
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
                            style: TextStyle(
                                fontSize: 17,
                                //fontWeight: FontWeight.bold,
                                color: Colors.blue),
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
                    showCustomDialog();
                  },
                ),
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
    );
  }

  showCustomDialog() {
    showDialog(
        context: context,
        builder: (context) => const AlertDialog(
              scrollable: true,
              content: LoginSuccessDialog(
                title: "Sign in successful!",
                desc: "Please wait... \nYou will be directed to the homepage.",
              ),
            ));
  }
}
