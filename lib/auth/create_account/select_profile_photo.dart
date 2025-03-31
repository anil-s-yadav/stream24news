import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream24news/auth/auth_service.dart';
import 'package:stream24news/auth/create_account/select_cuntory.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';

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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 2 columns
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: List.generate(50, (index) {
                    bool isSelected = selectedIndex != index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index; // Update selected index
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(width: 1, color: Colors.green)),
                          child: CircleAvatar(
                            backgroundColor: isSelected
                                ? Colors
                                    .primaries[index % Colors.primaries.length]
                                    .shade200
                                : Colors
                                    .primaries[index % Colors.primaries.length]
                                    .shade900,
                            child: SvgPicture.network(
                              'https://api.dicebear.com/7.x/adventurer/svg?seed=$index',
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    if (selectedIndex != null) {
                      await AuthService().updateUserProfile(
                          name: null,
                          photoUrl:
                              'https://api.dicebear.com/7.x/adventurer/svg?seed=$selectedIndex');
                      SharedPrefService().setProfilePhoto(
                          'https://api.dicebear.com/7.x/adventurer/svg?seed=$selectedIndex');

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelectCuntory(
                                    commingFrom: '',
                                  )));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Select a profile photo!")));
                    }
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
