import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream24news/models/new_model.dart';

import '../../utils/componants/sizedbox.dart';
import '../../utils/services/my_methods.dart';
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
  String errorInageUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNNLEL-qmmLeFR1nxJuepFOgPYfnwHR56vcw&s";

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
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedNetworkImage(
                                    imageUrl: widget
                                            .model[index].source?.sourceIcon ??
                                        errorInageUrl,
                                    height: 30,
                                    width: 30,
                                    // height: MediaQuery.of(context).size.height * 0.18,
                                    // width: MediaQuery.of(context).size.width * 0.38,
                                    // fit: BoxFit.fitHeight,
                                    placeholder: (context, url) => Container(
                                      // height: MediaQuery.of(context).size.height * 0.18,
                                      // width: MediaQuery.of(context).size.width * 0.38,
                                      height: 30,
                                      width: 30,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                // Image.asset(
                                //   "lib/assets/images/profile.png",
                                //   scale: 6,
                                // ),
                                sizedBoxW5(context),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    widget.model[index].source?.sourceName ??
                                        "Unknown",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                                // const Spacer(),
                                sizedBoxW5(context),
                                Icon(
                                  MyTabIcons.bookmark,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                newsMenuOptions(context)
                              ],
                            ),
                          ],
                        ),
                      ),
                      sizedBoxW10(context),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl:
                              widget.model[index].imageUrl ?? errorInageUrl,
                          height: MediaQuery.of(context).size.height * 0.18,
                          width: MediaQuery.of(context).size.width * 0.38,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width * 0.38,
                            color:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ]),
              );
            }),
      ),
    );
  }
}
