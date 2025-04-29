import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stream24news/models/new_model.dart';

import '../../utils/componants/sizedbox.dart';
import '../../utils/services/post_time.dart';
import '../../utils/theme/my_tab_icons_icons.dart';

class TrendingPage extends StatefulWidget {
  final String previousWidget;
  final List<Article> model;
  const TrendingPage(
      {super.key, required this.previousWidget, required this.model});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override
  Widget build(BuildContext context) {
    log("${widget.model.length}");
    log(widget.previousWidget, name: "Previous Widget");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.previousWidget),
        actions: [const Icon(MyTabIcons.searchh), sizedBoxW20(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.model.length,
            itemBuilder: (context, index) {
              String trendingPostedDate =
                  getTimeAgo(widget.model[index].pubDate);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.model[index].title ?? "",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                softWrap: true,
                                style: Theme.of(context).textTheme.titleMedium),
                            sizedBoxH5(context),
                            Text(
                              trendingPostedDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.outline,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  softWrap: true,
                                ),
                                const Spacer(),
                                Icon(
                                  MyTabIcons.bookmark,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                Icon(
                                  Icons.more_vert_rounded,
                                  color: Theme.of(context).colorScheme.outline,
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
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: Image.asset(
                            "lib/assets/images/test_sample1.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ]),
              );
            }),
      ),
    );
  }
}
