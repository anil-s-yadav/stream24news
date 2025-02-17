import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/my_tab_icons_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Center(
        child: Column(children: [
          // Text(
          //   "primarycolor",
          //   style: TextStyle(color: primaryColor),
          // ),
          // Text(
          //   "mateblack",
          //   style: TextStyle(color: mateBlack),
          // ),
          // Text(
          //   "coldgyar",
          //   style: TextStyle(color: coldGray),
          // ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("data"),
          ),
          PrimaryButton(text: "Follow", onPressed: () {}),
          SecondaryButton(text: "Follow", onPressed: () {}),
          Icon(
            MyTabIcons.home_button_fill,
            color: Theme.of(context).colorScheme.primary,
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 500,
            height: 200,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                "This is a conytainer.",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
