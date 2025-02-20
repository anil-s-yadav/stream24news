import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

class Samplepage extends StatelessWidget {
  const Samplepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Center(
        child: Column(children: [
          PrimaryButton(text: "Follow", onPressed: () {}),
          SecondaryButton(text: "Follow", onPressed: () {}),
          TersoryButton(text: "Follow", onPressed: () {}),
          Icon(
            MyTabIcons.home_button_fill,
            color: Theme.of(context).colorScheme.primary,
          ),
          Container(
            margin: const EdgeInsets.all(10),
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
          ),
          Text(
            "This is a conytainer.",
            style: GoogleFonts.dancingScript(fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}
