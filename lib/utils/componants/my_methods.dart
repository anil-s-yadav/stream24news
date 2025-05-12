import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/features/web_view/article_webview.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../dashboard/homepage/bloc/homepage_bloc.dart';
import '../../features/article_view/article_view.dart';

const String defaultImageUrl =
    "https://raw.githubusercontent.com/anil-s-yadav/stream24news_crm/refs/heads/main/lib/assets/news_app_logos/dark_app_logo.png";
// "https://raw.githubusercontent.com/anil-s-yadav/stream24news_crm/refs/heads/main/lib/assets/news_app_logos/app_logo.png";

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
        value: 0,
        child: Text("Open in Browser"),
      ),
      const PopupMenuItem<int>(
        value: 1,
        child: Text("Save"),
      ),
      const PopupMenuItem<int>(
        value: 2,
        child: Text("Report"),
      ),
    ],
    onSelected: (value) {
      if (value == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ArticleWebview(link: articleModel.link ?? "")));
      } else if (value == 1) {
        // Save article
        context
            .read<HomepageBloc>()
            .add(HomepageSaveArticleEvent(articleModel: articleModel));
      } else if (value == 2) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("What wrong?"),
                  content: TextFormField(),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () =>
                            EasyLoading.showSuccess("Article reported!"),
                        child: Text("Report"))
                  ],
                ));
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
