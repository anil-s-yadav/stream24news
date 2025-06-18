import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/dashboard/homepage/bloc/homepage_bloc.dart';
import 'package:stream24news/models/new_model.dart';

import '../../utils/componants/sizedbox.dart';
import '../../utils/componants/my_methods.dart';
import '../../utils/theme/my_tab_icons_icons.dart';
import '../article_view/article_view.dart';
import '../search_articles/search_page.dart';
import '../web_view/article_webview.dart';

class RecomenLatestPage extends StatefulWidget {
  final String previousWidget;
  final List<Article> model;
  const RecomenLatestPage(
      {super.key, required this.previousWidget, required this.model});

  @override
  State<RecomenLatestPage> createState() => _RecomenLatestPageState();
}

class _RecomenLatestPageState extends State<RecomenLatestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.previousWidget),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              child: const Icon(MyTabIcons.searchh)),
          sizedBoxW20(context)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.model.length,
            itemBuilder: (context, index) {
              String LatestPostedDate = getTimeAgo(widget.model[index].pubDate);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArticleView(
                              artical: widget.model,
                              index: index,
                              comeFrom: "T"))),
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              sizedBoxH5(context),
                              Text(
                                LatestPostedDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                softWrap: true,
                              ),
                              sizedBoxH5(context),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.model[index].source
                                              ?.sourceIcon ??
                                          defaultImageUrl,
                                      height: 30,
                                      width: 30,
                                      placeholder: (context, url) => Container(
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

                                  sizedBoxW5(context),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArticleWebview(
                                                      link: widget
                                                              .model[index]
                                                              .source
                                                              ?.sourceUrl ??
                                                          "")));
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Text(
                                        widget.model[index].source
                                                ?.sourceName ??
                                            "Unknown",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                  // const Spacer(),
                                  sizedBoxW5(context),
                                  GestureDetector(
                                    onTap: () => context
                                        .read<HomepageBloc>()
                                        .add(HomepageSaveArticleEvent(
                                            articleModel: widget.model[index])),
                                    child: Icon(
                                      MyTabIcons.bookmark,
                                      size: 20,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  newsMenuOptions(context, widget.model[index]),
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
                                widget.model[index].imageUrl ?? defaultImageUrl,
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.width * 0.38,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: MediaQuery.of(context).size.height * 0.18,
                              width: MediaQuery.of(context).size.width * 0.38,
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ]),
                ),
              );
            }),
      ),
    );
  }
}
