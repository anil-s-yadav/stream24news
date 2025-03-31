import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/auth/auth_service.dart';
import 'package:stream24news/auth/login/login_page.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import '../../utils/componants/sizedbox.dart';
import 'select_profile_photo.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  bool passwordVisibility = true;
  bool confirmPasswordVisibility = true;
  bool isLoading = false;

  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  String? validateEmail(String? email) {
    RegExp emailRegEx = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    if (email == null || !emailRegEx.hasMatch(email)) {
      return "Please enter a valid email";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Please enter your email and password to sign in",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.shadow,
                        fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
                sizedBoxH30(context),
                inputField("Name", "Enter name", (val) => name = val, name),
                inputField("Email", "Enter email", (val) => email = val, email,
                    isEmail: true),
                inputField("Password", "Enter password",
                    (val) => password = val, password,
                    isPassword: true),
                inputField("Confirm Password", "Confirm password",
                    (val) => confirmPassword = val, confirmPassword,
                    isConfirmPassword: true),
                sizedBoxH30(context),
                sizedBoxH30(context),
                const Divider(indent: 30, endIndent: 30, color: Colors.black12),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height * 0.02),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        signUp();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const SelectProfilePhoto()),
                        // );
                      }
                    },
                  ),
                ),
                sizedBoxH30(context),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "By creating an account, you agree to our ",
                        style: TextStyle(fontSize: 12),
                      ),
                      const Text(
                        "Terms & Policy.",
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(
    String title,
    String hint,
    Function(String) onSaved,
    String initialValue, {
    bool isEmail = false,
    bool isPassword = false,
    bool isConfirmPassword = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(30.0),
          shadowColor: Colors.black26,
          child: TextFormField(
            initialValue: initialValue,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "This field cannot be empty!";
              }
              if (isEmail) {
                return validateEmail(value);
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                onSaved(value);
              }
            },
            obscureText: isPassword
                ? passwordVisibility
                : (isConfirmPassword ? confirmPasswordVisibility : false),
            cursorColor: Theme.of(context).colorScheme.primary,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: MediaQuery.of(context).size.width * 0.005,
                ),
              ),
              suffixIcon: isPassword || isConfirmPassword
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isPassword) {
                            passwordVisibility = !passwordVisibility;
                          } else {
                            confirmPasswordVisibility =
                                !confirmPasswordVisibility;
                          }
                        });
                      },
                      child: Icon(
                        (isPassword
                                ? passwordVisibility
                                : confirmPasswordVisibility)
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    EasyLoading.show(status: 'Creating account...'); // Show loading

    try {
      final user =
          await AuthService().createUserWithEmailAndPassword(email, password);

      if (user != null) {
        await AuthService().updateUserProfile(name: name, photoUrl: null);

        EasyLoading.dismiss(); // Hide loading

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created! Verify your email.")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectProfilePhoto()),
        );
      }
    } catch (e) {
      EasyLoading.dismiss(); // Hide loading on error

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}
