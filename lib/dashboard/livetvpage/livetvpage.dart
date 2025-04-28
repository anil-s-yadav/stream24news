import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream24news/dashboard/livetvpage/bloc/live_tv_bloc.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../auth/create_account/list_data/country_data.dart';
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
  bool isAllSelected = false;
  String _selectedLanguage = 'Hindi';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    final region = SharedPrefService().getCounty()![2];
    context.read<LiveTvBloc>().add(LiveTvDataLoadEvent(resion: region));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            buildFilterOptions(
              context: context,
              isAllSelected: isAllSelected,
              selectedLanguage: _selectedLanguage,
              onAllSelected: (selected) {
                loadData();
                setState(() => isAllSelected = selected);
              },
              onLanguageSelected: (lang) => setState(() {
                _selectedLanguage = lang;
                isAllSelected = false;
              }),
              onInfoClick: () {},
            ),
            sizedBoxH10(context),
            Expanded(child: _buildChannelList()),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: isSeachVisible ? _buildSearchBar(context) : _buildTitle(context),
      actions: [
        IconButton(
          icon: Icon(
            isSeachVisible ? Icons.cancel_outlined : MyTabIcons.searchh,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => setState(() => isSeachVisible = !isSeachVisible),
        ),
        IconButton(
            icon: Icon(
              Icons.swap_vert,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => myBottomSheet(context)),
        sizedBoxW10(context),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SearchBar(
      elevation: const WidgetStatePropertyAll(0),
      hintText: 'Search...',
      trailing: [
        Icon(MyTabIcons.searchh, color: Theme.of(context).colorScheme.primary),
        sizedBoxW5(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Watch ',
        style: TextStyle(
            color: Theme.of(context).colorScheme.shadow, fontSize: 13),
        children: [
          TextSpan(
            text: 'Live TV',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(text: ' here!'),
        ],
      ),
    );
  }

  Widget _buildChannelList() {
    return BlocBuilder<LiveTvBloc, LiveTvState>(
      builder: (context, state) {
        if (state is LiveTvInitialState) return channelsLoading(context);
        if (state is LiveTvSuccessState) {
          final channels = state.liveChannelModel;
          if (channels.isEmpty)
            return const Center(child: Text("No channels available"));
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              final language = languages.entries
                  .firstWhere((e) => e.value == channel.language)
                  .key;
              return _buildChannelItem(channel, language);
            },
          );
        }
        if (state is LiveTvErrorState)
          return const Center(child: Text("Error state"));
        return const Center(child: Text("Error outside if else"));
      },
    );
  }

  Widget _buildChannelItem(channel, String language) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => VideoPlayScreen())),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
                child: Image.network(
              channel.logo,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(),
            )),
            Text(channel.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(language,
                style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      ),
    );
  }

  void myBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sort", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 15,
                  runSpacing: 20,
                  children: [
                    "A - Z",
                    "Z - A",
                    "Newest First",
                    "Oldest First",
                    "Most Popular"
                  ]
                      .map((text) => SecondaryButton(
                          textWidget: Text(text), onPressed: () {}))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget channelsLoading(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      children: List.generate(
        12,
        (index) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

Widget buildFilterOptions({
  required BuildContext context,
  required bool isAllSelected,
  required String? selectedLanguage,
  required void Function(bool) onAllSelected,
  required void Function(String) onLanguageSelected,
  required void Function() onInfoClick,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      ChoiceChip(
        label: Text('All Channels',
            style: TextStyle(
              color: isAllSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            )),
        selected: isAllSelected,
        showCheckmark: false,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        side: BorderSide(
          color: isAllSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onSelected: (bool selected) {
          onAllSelected(selected);
        },
      ),
      Container(
        height: 37,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedLanguage,
            hint: Text(
              'Select Language',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            iconEnabledColor: Theme.of(context).colorScheme.primary,
            items: languages.keys.map((key) {
              return DropdownMenuItem(
                value: key,
                child: Text(
                  key,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                onLanguageSelected(newValue);
              }
            },
          ),
        ),
      ),
      Icon(
        Icons.info_outline,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        size: 30,
      )
    ],
  );
}
