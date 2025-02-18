import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/my_tab_icons_icons.dart';

class LiveTvPage extends StatefulWidget {
  const LiveTvPage({super.key});

  @override
  State<LiveTvPage> createState() => _LiveTvPageState();
}

class _LiveTvPageState extends State<LiveTvPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
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
        actions: const [
          Icon(MyTabIcons.searchh),
          sizedBoxW10,
          Icon(MyTabIcons.tabview),
          sizedBoxW10
        ],
      ),
      body: Container(),
    );
  }
}
