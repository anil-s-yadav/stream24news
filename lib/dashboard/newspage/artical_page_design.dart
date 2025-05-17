import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import '../../features/web_view/article_webview.dart';
import '../../utils/componants/my_methods.dart';
import 'animated_link_box.dart';

class ArticlePageDesign extends StatefulWidget {
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
  State<ArticlePageDesign> createState() => _ArticlePageDesignState();
}

class _ArticlePageDesignState extends State<ArticlePageDesign> {
  String? selectedCategoryTitle;
  @override
  void initState() {
    super.initState();
    increaseView(widget.article.articleId.toString());
  }

  @override
  Widget build(BuildContext context) {
    String date = getTimeAgo(widget.article.pubDate);

    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          color: Theme.of(context).canvasColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: widget.article.imageUrl ?? defaultImageUrl,
                  height: MediaQuery.of(context).size.height * 0.27,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: newsMenuOptions(context, widget.article)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ArticleWebview(link: widget.article.link ?? "")));
                },
                child: AnimatedLogoLinkBox(
                  link: widget.article.link ?? "No link",
                  logoUrl: widget.article.source?.sourceIcon ?? defaultImageUrl,
                ),
              ),
            ],
          ),

          ////////////////////////////////////
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.article.source?.sourceName ?? 'Source'}  |   $date",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: Theme.of(context).hintColor,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  sizedBoxH10(context),
                  // Text(
                  //   widget.article.title ?? "No Title",
                  //   maxLines: 4,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: Theme.of(context).textTheme.titleLarge,

                  // ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final span = TextSpan(
                        text: widget.article.title ?? "No Title",
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                      final tp = TextPainter(
                        text: span,
                        maxLines: 3,
                        textDirection: TextDirection.ltr,
                      )..layout(maxWidth: constraints.maxWidth);

                      if (tp.didExceedMaxLines) {
                        return Text(
                          widget.article.title ?? "No Title",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.left,
                        );
                      } else {
                        return Text(
                          widget.article.title ?? "No Title",
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.left,
                        );
                      }
                    },
                  ),

                  sizedBoxH5(context),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.article.description ?? "No description",
                          maxLines: 12,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Theme.of(context).hintColor,
                                fontSize: 16,
                              ),
                          textAlign: TextAlign.left,
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArticleWebview(
                                          link: widget.article.link ?? "")));
                            },
                            child: Text(
                              'Read More',
                              style: TextStyle(
                                // color: Theme.of(context).primaryColor,
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    /* LayoutBuilder(
                      builder: (context, constraints) {
                        final span = TextSpan(
                          text: widget.article.description ?? "No description",
                          style: Theme.of(context).textTheme.titleSmall,
                        );
                        final tp = TextPainter(
                          text: span,
                          maxLines: 12,
                          textDirection: TextDirection.ltr,
                        )..layout(maxWidth: constraints.maxWidth);

                        if (tp.didExceedMaxLines) {
                          return Column(
                            children: [
                              Text(
                                widget.article.description ?? "No description",
                                maxLines: 12,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 16,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ArticleWebview(
                                                    link: widget.article.link ??
                                                        "")));
                                  },
                                  child: Text(
                                    'Read More',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                widget.article.description ?? "No description",
                                maxLines: 12,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 16,
                                    ),
                                textAlign: TextAlign.left,
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ArticleWebview(
                                                    link: widget.article.link ??
                                                        "")));
                                  },
                                  child: Text(
                                    'Read More',
                                    style: TextStyle(
                                      // color: Theme.of(context).primaryColor,
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                      },*/
                  ),
                ],
              ),
            ),
          ),

          //////////////////////////////////////////////
          Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: double.infinity,
            color: Theme.of(context).hintColor,
            child: Center(
              child: Text(
                "Advertisement!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void increaseView(String articleId) {
    Timer(Duration(seconds: 5), () async {
      final docRef =
          FirebaseFirestore.instance.collection('news').doc(articleId);
      // Use a transaction to safely increment the view count
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final currentViews = snapshot.get('views') ?? 0;
        transaction.update(docRef, {'views': currentViews + 1});
      });
    });
  }
}
