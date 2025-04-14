import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream24news/dashboard/livetvpage/bloc/live_tv_bloc.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../auth/create_account/list_data/language_data.dart';
import '../../features/video_play_screen/video_play_screen.dart';
import '../../utils/componants/my_widgets.dart';

class LiveTvPage extends StatefulWidget {
  const LiveTvPage({super.key});

  @override
  State<LiveTvPage> createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> {
  bool isSeachVisible = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    List<String>? regionList = SharedPrefService().getCounty();
    String region = regionList![2];
    log('Country list :  $regionList');
    log('Country code:  $region');
    context.read<LiveTvBloc>().add(LiveTvDataLoadEvent(resion: region));
  }

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
            Expanded(
              child: BlocBuilder<LiveTvBloc, LiveTvState>(
                builder: (context, state) {
                  if (state is LiveTvInitialState) {
                    return channelsLoading(context);
                  } else if (state is LiveTvSuccessState) {
                    final channels = state.liveChannelModel;

                    if (channels.isEmpty) {
                      return const Center(child: Text("No channels available"));
                    } else {
                      return GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: channels.length,
                        itemBuilder: (context, index) {
                          final channel = channels[index];
                          String language = languages.entries
                              .firstWhere(
                                  (entry) => entry.value == channel.language)
                              .key;
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoPlayScreen()));
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      channel.logo,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  Text(channel.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(language,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  } else if (state is LiveTvErrorState) {
                    return Text("Error state");
                  }
                  return Center(child: const Text("error oitside if else"));
                },
              ),
            )
          ],
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
                        SecondaryButton(
                            textWidget: Text("Most Popular"), onPressed: () {}),
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

  channelsLoading(BuildContext context) {
    GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      shrinkWrap: true,
      children: List.generate(
        12,
        (index) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                  child: Container(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
              )),
            ),
          );
        },
      ),
    );
  }
}
