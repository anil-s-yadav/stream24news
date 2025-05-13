import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../features/web_view/article_webview.dart';
import '../../utils/componants/my_methods.dart';
import 'animated_link_box.dart';

class ArticlePageDesign extends StatelessWidget {
  final Article article;
  final bool isTransitioning;
  final bool isArticleView;

  const ArticlePageDesign({
    super.key,
    required this.article,
    this.isTransitioning = false,
    this.isArticleView = false,
  });

  @override
  Widget build(BuildContext context) {
    String date = getTimeAgo(article.pubDate);

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
      padding: EdgeInsets.only(top: 10),
      // height: MediaQuery.of(context).size.height * 0.8029,
      // duration: const Duration(milliseconds: 300),
      // curve: Curves.easeInOut,
      // margin: EdgeInsets.all(isTransitioning ? 10 : 0),
      // margin: EdgeInsets.all(isTransitioning ? 10 : 0),
      decoration: BoxDecoration(
        color: Colors.black87,
        // borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(30), topRight: Radius.circular(30))
        // borderRadius: BorderRadius.circular(isTransitioning ? 30 : 0),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // sizedBoxH30(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("For You",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 12)),
                  Text("Trending",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                          fontSize: 12)),
                  Text("Recomanded",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                          fontSize: 12)),
                  Text("Select category",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white54,
                          fontSize: 12)),
                  // Icon(Icons.arrow_drop_down_rounded,
                  //     size: 24,
                  //     color: Theme.of(context).colorScheme.onPrimary),
                ],
              ),
              sizedBoxH10(context),
              ClipRRect(
                // borderRadius: BorderRadius.circular(12),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: article.imageUrl ?? defaultImageUrl,
                  height: MediaQuery.of(context).size.height * 0.27,
                  // color: Colors.black,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),

              ////////////////////////////////////
              Container(
                color: Theme.of(context).canvasColor,
                height: isArticleView
                    ? MediaQuery.of(context).size.height * 0.53
                    : MediaQuery.of(context).size.height * 0.46,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title ?? "No Title",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          // color: Theme.of(context).hintColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 8),
                      sizedBoxH5(context),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final span = TextSpan(
                              text: article.description ?? "No description",
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 18,
                              ),
                            );
                            final tp = TextPainter(
                              text: span,
                              maxLines: 13,
                              textDirection: TextDirection.ltr,
                            )..layout(maxWidth: constraints.maxWidth);

                            if (tp.didExceedMaxLines) {
                              return Column(
                                children: [
                                  Text(
                                    article.description ?? "No description",
                                    maxLines: 13,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(
                                          color: Theme.of(context).hintColor,
                                          fontSize: 18,
                                        ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        EasyLoading.showToast("soon!");
                                      },
                                      child: Text(
                                        'Read More',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Text(
                                article.description ?? "No description",
                                maxLines: 13,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 18,
                                    ),
                                textAlign: TextAlign.left,
                              );
                            }
                          },
                        ),
                      ),
                      Text(
                        "${article.source?.sourceName ?? 'Source'}  |   $date",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: Theme.of(context).hintColor,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              //////////////////////////////////////////////
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: double.infinity,
                color: Colors.black87,
                child: Center(
                  child: Text(
                    "Advertisement!",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              // isArticleView
              //     ? Container(
              //         height: MediaQuery.of(context).size.height * 0.08,
              //         width: double.infinity,
              //         color: Colors.black87,
              //         child: Center(
              //           child: Text(
              //             "Advertisement!",
              //             style: TextStyle(color: Colors.white, fontSize: 20),
              //           ),
              //         ),
              //       )
              //     : SizedBox.shrink()
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.04,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.more_vert,
                size: 18,
                // color: Theme.of(context).colorScheme.onSurface,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.265,
            left: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ArticleWebview(link: article.link ?? "")));
              },
              child: AnimatedLogoLinkBox(
                link: article.link ?? "No link",
                logoUrl: article.source?.sourceIcon ?? defaultImageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
