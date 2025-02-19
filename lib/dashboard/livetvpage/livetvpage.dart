import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/my_tab_icons_icons.dart';

class LiveTvPage extends StatefulWidget {
  const LiveTvPage({super.key});

  @override
  State<LiveTvPage> createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> {
  bool isSeachVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSeachVisible
            ? SearchBar(
                elevation: WidgetStatePropertyAll(0),
                hintText: 'Search...',
                trailing: [
                  Icon(
                    MyTabIcons.searchh,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  sizedBoxW5
                ],
              )
            : RichText(
                text: TextSpan(
                  text: 'Watch ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Live TV',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' here!'),
                  ],
                ),
              ),
        actions: [
          GestureDetector(
              onTap: () {
                setState(() {
                  isSeachVisible = !isSeachVisible;
                });
              },
              child: Icon(
                isSeachVisible ? Icons.cancel_outlined : MyTabIcons.searchh,
              )),
          sizedBoxW10,
          Icon(MyTabIcons.tabview),
          sizedBoxW10
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Center(
                    child: Text("Banner ad",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ))),
              ),
              sizedBoxH15,
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                shrinkWrap: true,
                children: List.generate(
                  20,
                  (index) {
                    return Container(
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "lib/assets/images/profile.png",
                              scale: 1.5,
                            ),
                            sizedBoxH5,
                            Text(
                              maxLines: 1,
                              "Channel Name",
                              style: Theme.of(context).textTheme.labelSmall,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
