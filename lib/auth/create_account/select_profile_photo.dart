import 'package:flutter/material.dart';
import 'package:stream24news/auth/create_account/select_cuntory.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

class SelectProfilePhoto extends StatefulWidget {
  const SelectProfilePhoto({super.key});

  @override
  State<SelectProfilePhoto> createState() => _SelectProfilePhotoState();
}

class _SelectProfilePhotoState extends State<SelectProfilePhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select profile photo",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  "Choose a profile photo that  image will be not visible to others and it\' private to you only.",
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  textAlign: TextAlign.start,
                ),
              ),
              sizedBoxH30(context),
              Image.asset(
                "lib/assets/images/profile.png",
                scale: 0.5,
              ),
              sizedBoxH30(context),
              OutlinedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  iconSize: 30,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                ),
                icon: const Icon(Icons.image),
                label: const Text("Select image"),
              ),
              sizedBoxH30(context),
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SelectCuntory()));
                  },
                  style: IconButton.styleFrom(
                    iconSize: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                  ),
                  icon: Icon(Icons.arrow_forward_ios_rounded))
            ],
          ),
        ),
      ),
    );
  }
}
