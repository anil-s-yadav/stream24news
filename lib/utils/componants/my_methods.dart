import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:stream24news/features/web_view/article_webview.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../dashboard/homepage/bloc/homepage_bloc.dart';

const String defaultImageUrl =
    "https://raw.githubusercontent.com/anil-s-yadav/stream24news_crm/refs/heads/main/lib/assets/news_app_logos/dark_app_logo.jpeg";

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

Widget newsMenuOptions(BuildContext context, Article article) {
  return PopupMenuButton<int>(
    color: Theme.of(context).scaffoldBackgroundColor,
    onSelected: (value) {
      switch (value) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleWebview(link: article.link ?? ''),
            ),
          );
          break;
        case 1:
          context.read<HomepageBloc>().add(
                HomepageSaveArticleEvent(articleModel: article),
              );
          break;
        case 2:
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("What's wrong?"),
              content: TextFormField(),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    EasyLoading.showSuccess("Article reported!");
                    Navigator.pop(context);
                  },
                  child: Text("Report"),
                ),
              ],
            ),
          );
          break;
      }
    },
    itemBuilder: (_) => [
      const PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(
                Icons.language,
                color: Colors.green,
                size: 22,
                weight: 14,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Open in Browser",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.green),
              ),
            ],
          )),
      const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(
                MyTabIcons.bookmark,
                color: Colors.blue,
                size: 22,
                weight: 14,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Save",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
              ),
            ],
          )),
      const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(
                Icons.flag_outlined,
                color: Colors.green,
                size: 22,
                weight: 14,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Report",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.red),
              ),
            ],
          )),
    ],
  );
}

Widget noDataWidget(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          sizedBoxH10(context),
          Image.asset(
            "lib/assets/images/no_data.png",
            height: MediaQuery.of(context).size.height * 0.25,
            fit: BoxFit.contain,
          ),
          // SizedBox(height: 24),
          Text(
            "No Data Available",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          sizedBoxH5(context),
          Text(
            "We couldn’t find any data for your selected country or language.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          sizedBoxH10(context),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoBullet("Try changing your selected country.", context),
              infoBullet("Try changing your preferred language.", context),
              infoBullet(
                  "Ensure you have a stable internet connection.", context),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget infoBullet(String text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            )),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );
}
