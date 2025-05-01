import 'package:flutter/material.dart';

const String defaultImageUrl =
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNNLEL-qmmLeFR1nxJuepFOgPYfnwHR56vcw&s";

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

Widget newsMenuOptions(BuildContext context) {
  return PopupMenuButton<int>(
    icon: Icon(
      Icons.more_vert_outlined,
      size: 24,
      color: Theme.of(context).colorScheme.primary,
    ),
    // splashRadius: 12,

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
      if (value == 1) {
      } else if (value == 2) {}
    },
  );
}
