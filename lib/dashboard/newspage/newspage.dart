import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

class Newspage extends StatelessWidget {
  const Newspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TersoryButton(
                text: "My Button",
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("My Button")));
                }),
            ElevatedButton(
                onPressed: () {
                  myBottomsheet(context);
                },
                child: const Text("data")),
          ],
        ),
      ),
    );
  }

  myBottomsheet(BuildContext context) {
    showModalBottomSheet(
      showDragHandle: true,
      // isScrollControlled: true,
      // scrollControlDisabledMaxHeightRatio: 10,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) => SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sizedBoxH5,
              Row(
                children: [
                  Text(
                    "Sort",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  Text(
                    "Cancel",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                  sizedBoxW15,
                  const Text(
                    "Apply",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 118, 31),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              sizedBoxH5,
              Wrap(spacing: 15, children: [
                SecondaryButton(text: "A - Z", onPressed: () {}),
                SecondaryButton(text: "Z - A", onPressed: () {}),
                SecondaryButton(text: "Newest First", onPressed: () {}),
                SecondaryButton(text: "Oldest First", onPressed: () {}),
              ]),
              sizedBoxH10,
              const Divider(),
              sizedBoxH20,
              Text(
                "Filter by",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              sizedBoxH5,
            ],
          ),
        ),
      ),
    );
  }
}
