import 'package:flutter/material.dart';
import 'package:stream24news/auth/presentation/login_page.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import '../../utils/componants/sizedbox.dart';
import 'select_profile_photo.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
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
              TextField(
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
                            style: TextStyle(fontSize: 17, color: Colors.blue),
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectProfilePhoto()));
                  },
                ),
              ),
              sizedBoxH20(context),
            ],
          ),
        ),
      ),
    );
  }
}
