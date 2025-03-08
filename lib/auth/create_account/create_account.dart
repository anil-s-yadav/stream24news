import 'package:flutter/material.dart';
import 'package:stream24news/auth/login/login_page.dart';
import 'package:stream24news/auth/network/auth_service.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import '../../utils/componants/sizedbox.dart';
import 'select_profile_photo.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _myAuth = AuthService();
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
                    "Create Account 🧑‍💼",
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
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 8) {
                      return 'At least 8 characters long.';
                    }
                    return null;
                  },
                ),
                sizedBoxH10(context),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                        "By creating account, you agree to Stream24 News ",
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
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.02),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account?  ',
                          style: TextStyle(fontSize: 15),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                sizedBoxH30(context),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: PrimaryButton(
                    textWidget: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: _createAccoumt,
                    // () {
                    //   _createAccoumt;
                    //   // Navigator.pushReplacement(
                    //   //     context,
                    //   //     MaterialPageRoute(
                    //   //         builder: (context) =>
                    //   //             const SelectProfilePhoto()));
                    // },
                  ),
                ),
                sizedBoxH20(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _createAccoumt() async {
    try {
      final user = await _myAuth.createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        print("User ID: ${user.uid}");
        print("Name: ${user.displayName}");
        print("Email: ${user.email}");
        print("Phone: ${user.phoneNumber}");
        print("Photo URL: ${user.photoURL}");
        // showCustomDialog();
      }
    } catch (e) {
      //  _showErrorMessage("Something went wrong. Please try again.");
    }
  }
}
