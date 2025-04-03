import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream24news/auth/auth_service.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';

import 'select_cuntory.dart';

class SelectProfilePhoto extends StatefulWidget {
  const SelectProfilePhoto({super.key});

  @override
  State<SelectProfilePhoto> createState() => _SelectProfilePhotoState();
}

class _SelectProfilePhotoState extends State<SelectProfilePhoto> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Profile Photo")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Select a Profile Photo",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  "Choose a profile photo. This image will be private and not visible to others.",
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedIndex == index
                                ? Colors.green
                                : Colors.grey,
                            width: selectedIndex == index ? 3 : 1,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors
                              .primaries[index % Colors.primaries.length]
                              .shade200,
                          child: SvgPicture.network(
                            'https://api.dicebear.com/7.x/adventurer/svg?seed=$index',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              sizedBoxH10(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  selectedIndex != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors
                              .primaries[
                                  selectedIndex! % Colors.primaries.length]
                              .shade200,
                          child: SvgPicture.network(
                            'https://api.dicebear.com/7.x/adventurer/svg?seed=$selectedIndex',
                          ),
                        )
                      : const SizedBox(),
                  IconButton(
                    onPressed: () async {
                      if (selectedIndex != null) {
                        String selectedPhotoUrl =
                            'https://api.dicebear.com/7.x/adventurer/svg?seed=$selectedIndex';

                        bool isLoggedIn = AuthService().isUserLoggedIn();

                        if (isLoggedIn) {
                          try {
                            await AuthService().updateUserProfile(
                              name: null,
                              photoUrl: selectedPhotoUrl,
                            );
                          } catch (e) {
                            debugPrint("Error updating user profile: $e");
                          }
                        }

                        // await SharedPrefService()
                        //     .setProfilePhoto(selectedPhotoUrl);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SelectCuntory(commingFrom: ''),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please select a profile photo!")),
                        );
                      }
                    },
                    iconSize: 50,
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
