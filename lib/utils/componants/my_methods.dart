import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../dashboard/homepage/bloc/homepage_bloc.dart';

const String defaultImageUrl =
    "https://raw.githubusercontent.com/anil-s-yadav/stream24news_crm/refs/heads/main/lib/assets/news_app_logos/app_logo.png";

String getTimeAgo(String? pubDate) {
  // Parse the published date as UTC
  DateTime published = DateTime.parse(pubDate!).toUtc();
  // Get current date in UTC
  DateTime now = DateTime.now().toUtc();
  // Calculate difference
  Duration diff = now.difference(published);

  if (diff.inDays > 1) {
    return "${diff.inDays} days ago";
  } else if (diff.inDays == 1) {
    return "1 day ago";
  } else if (diff.inHours >= 1) {
    return "${diff.inHours} hours ago";
  } else if (diff.inMinutes >= 1) {
    return "${diff.inMinutes} minutes ago";
  } else {
    return "Just now";
  }
}

Widget newsMenuOptions(BuildContext context, Article articleModel) {
  return PopupMenuButton<int>(
    icon: Icon(
      Icons.more_vert_outlined,
      size: 24,
      color: Theme.of(context).colorScheme.primary,
    ),
    itemBuilder: (context) => [
      const PopupMenuItem<int>(
        value: 1,
        child: Text("Read summary"),
      ),
      const PopupMenuItem<int>(
        value: 2,
        child: Text("Open in Browser"),
      ),
      const PopupMenuItem<int>(
        value: 3,
        child: Text("Save"),
      ),
      const PopupMenuItem<int>(
        value: 4,
        child: Text("Report"),
      ),
    ],
    onSelected: (value) {
      if (value == 3) {
        // Save article
        context
            .read<HomepageBloc>()
            .add(HomepageSaveArticleEvent(articleModel: articleModel));
      }
    },
  );
}

Widget noDataWidget(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "lib/assets/images/no_data.png",
          scale: 6,
        ),
        sizedBoxH20(context),
        Text(
          "No Data Available for you countory or language. \n Please try to change your country or language.",
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    ),
  );
}
