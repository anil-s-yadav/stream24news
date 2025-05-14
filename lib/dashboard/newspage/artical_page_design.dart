import 'package:cached_network_image/cached_network_image.dart';
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
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.more_vert,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
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
                  Text(
                    widget.article.title ?? "No Title",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                    // style: TextStyle(
                    //   fontSize: 18,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                  sizedBoxH5(context),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final span = TextSpan(
                          text: widget.article.description ?? "No description",
                          style: Theme.of(context).textTheme.titleSmall,
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
                                widget.article.description ?? "No description",
                                maxLines: 13,
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArticleWebview(
                                          link: widget.article.link ?? "")));
                            },
                            child: Text(
                              widget.article.description ?? "No description",
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
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          //////////////////////////////////////////////
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
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
}
