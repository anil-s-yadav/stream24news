import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/models/new_model.dart';

import '../../utils/componants/sizedbox.dart';
import '../../utils/services/my_methods.dart';
import '../../utils/theme/my_tab_icons_icons.dart';

class ArticlePageDesign extends StatelessWidget {
  final Article article;
  const ArticlePageDesign({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: CachedNetworkImage(
                imageUrl: article.imageUrl ?? defaultImageUrl,
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    MyTabIcons.bookmark,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        sizedBoxH20(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            article.title ?? "No Title",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.left,
          ),
        ),
        sizedBoxH20(context),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            article.description ?? "No description",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
            textAlign: TextAlign.left,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              // color: Theme.of(context).colorScheme.primaryContainer,
              color: Theme.of(context).colorScheme.surfaceDim,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                  article.source?.sourceIcon ?? defaultImageUrl,
                )),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    article.link ?? "No link",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
