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
                textWidget: const Text("My Button"),
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
              sizedBoxH5(context),
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
                  sizedBoxW15(context),
                  const Text(
                    "Apply",
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 118, 31),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              sizedBoxH5(context),
              Wrap(spacing: 15, children: [
                SecondaryButton(
                    textWidget: const Text("A - Z"), onPressed: () {}),
                SecondaryButton(
                    textWidget: const Text("Z - A"), onPressed: () {}),
                SecondaryButton(
                    textWidget: const Text("Newest First"), onPressed: () {}),
                SecondaryButton(
                    textWidget: const Text("Oldest First"), onPressed: () {}),
              ]),
              sizedBoxH10(context),
              const Divider(),
              sizedBoxH20(context),
              Text(
                "Filter by",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              sizedBoxH5(context),
            ],
          ),
        ),
      ),
    );
  }
}
