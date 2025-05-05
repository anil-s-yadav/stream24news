import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream24news/models/new_model.dart';

import '../../utils/services/my_methods.dart';
import '../../utils/theme/my_tab_icons_icons.dart';
import 'animated_link_box.dart';

class ArticlePageDesign extends StatelessWidget {
  final Article article;
  const ArticlePageDesign({super.key, required this.article});
  @override
  Widget build(BuildContext context) {
    String date = getTimeAgo(article.pubDate);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl ?? defaultImageUrl,
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // sizedBoxH20(context),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 22),
              child: Text(
                article.title ?? "No Title",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).hintColor,
                      fontWeight: FontWeight.bold,
                    ),
                // textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              child: Text(
                article.description ?? "No description",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Theme.of(context).hintColor, fontSize: 20),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Text(
                "${article.source?.sourceName ?? 'Source'}  |   $date",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11, color: Theme.of(context).disabledColor),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        Positioned(
            top: 320,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 32,
              width: 90,
              // margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    MyTabIcons.bookmark,
                    size: 20,
                    color: Colors.black,
                  ),
                  Spacer(),
                  Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.black,
                  ),
                ],
              ),
            )),
        AnimatedLogoLinkBox(
          link: article.link ?? "No link",
          logoUrl: article.source?.sourceIcon ?? defaultImageUrl,
        ),
      ],
    );
  }
}
