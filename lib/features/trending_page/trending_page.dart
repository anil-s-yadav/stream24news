import 'package:flutter/material.dart';

import '../../utils/componants/sizedbox.dart';
import '../../utils/theme/my_tab_icons_icons.dart';

class TrendingPage extends StatefulWidget {
  final String previousWidget;
  const TrendingPage({super.key, required this.previousWidget});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.previousWidget),
        actions: [const Icon(MyTabIcons.searchh), sizedBoxW20(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                          softWrap: true,
                                          "You should know knowkn owkno wknow knowk now web requests in your chosen programming ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      sizedBoxH5(context),
                                      Text(
                                        "  9 dats ago",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                        softWrap: true,
                                      ),
                                      sizedBoxH5(context),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "lib/assets/images/profile.png",
                                            scale: 6,
                                          ),
                                          sizedBoxW5(context),
                                          Text(
                                            "Anil Yadav",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            softWrap: true,
                                          ),
                                          const Spacer(),
                                          Icon(
                                            MyTabIcons.bookmark,
                                            size: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                          Icon(
                                            Icons.more_vert_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                sizedBoxW10(context),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.18,
                                    width: MediaQuery.of(context).size.width *
                                        0.38,
                                    child: Image.asset(
                                      "lib/assets/images/test_sample1.jpg",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
