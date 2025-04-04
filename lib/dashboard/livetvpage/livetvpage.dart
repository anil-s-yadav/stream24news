import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../auth/create_account/list_data/language_data.dart';
import '../../utils/componants/my_widgets.dart';

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
                elevation: const WidgetStatePropertyAll(0),
                hintText: 'Search...',
                trailing: [
                  Icon(
                    MyTabIcons.searchh,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  sizedBoxW5(context)
                ],
              )
            : RichText(
                text: TextSpan(
                  text: 'Watch ',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.shadow,
                      fontSize: 12),
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
          sizedBoxW15(context),
          GestureDetector(
              onTap: () => myBottomSheet(context),
              child: const Icon(MyTabIcons.tabview)),
          sizedBoxW20(context)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
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
              sizedBoxH15(context),
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
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: CachedNetworkImage(
                                    scale: 10,
                                    imageUrl:
                                        "https://firebasestorage.googleapis.com/v0/b/live-tv-6f21f.appspot.com/o/imageContent-834-j5m9nrrs-m1.png?alt=media&token=0045e79c-b2da-4805-b25b-5b202ee71a4d"),
                              ),
                              sizedBoxH5(context),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                "NDTV India",
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          ),
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

  myBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true, // Enables the draggable handle
      isScrollControlled: true, // Allows the bottom sheet to expand fully
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6, // Starting size (50% of screen height)
        minChildSize: 0.3, // Minimum collapsed size
        maxChildSize: 0.9, // Maximum expanded size
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Sort",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            // Add your apply logic here
                          },
                          child: const Text(
                            "Apply",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 118, 31),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    sizedBoxW10(context),
                    Wrap(
                      spacing: 15,
                      runSpacing: 10,
                      children: [
                        SecondaryButton(
                            textWidget: Text("A - Z"), onPressed: () {}),
                        SecondaryButton(
                            textWidget: Text("Z - A"), onPressed: () {}),
                        SecondaryButton(
                            textWidget: Text("Newest First"), onPressed: () {}),
                        SecondaryButton(
                            textWidget: Text("Oldest First"), onPressed: () {}),
                      ],
                    ),
                    sizedBoxH20(context),
                    const Divider(),
                    sizedBoxW20(context),
                    // Filter by Section
                    Text(
                      "Filter by",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    sizedBoxH10(context),

                    // List of Filters
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true, // Prevents infinite height issues
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        final languageList = languages.entries.toList();

                        return ListTile(
                          leading: Checkbox(
                            value:
                                false, // Replace with dynamic value if needed
                            onChanged: (bool? newValue) {
                              // Handle checkbox state change
                            },
                          ),
                          title: Text(languageList[index].key),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
