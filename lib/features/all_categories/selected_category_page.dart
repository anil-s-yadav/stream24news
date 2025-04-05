import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

class SelectedCategoryPage extends StatefulWidget {
  final Map<String, dynamic> selectedCategory;

  const SelectedCategoryPage({super.key, required this.selectedCategory});

  @override
  State<SelectedCategoryPage> createState() => _SelectedCategoryPageState();
}

class _SelectedCategoryPageState extends State<SelectedCategoryPage> {
  @override
  Widget build(BuildContext context) {
    log(widget.selectedCategory['image']);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedCategory['title']),
        actions: [Icon(MyTabIcons.searchh), sizedBoxW20(context)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              width: double.maxFinite,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.selectedCategory['image'],
                    fit: BoxFit.fitWidth,
                  )),
            ),
            sizedBoxH20(context),
            Row(
              children: [
                Text(
                  "Sort by",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Spacer(),
                Text(
                  "Most Popular",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Icon(
                  Icons.swap_vert,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return categoryWidgetData();
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget categoryWidgetData() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.38,
                child: Image.asset(
                  widget.selectedCategory['image'],
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            sizedBoxW10(context),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      softWrap: true,
                      "You should know knowknowknowknowknowknow web requests in your chosen programming ",
                      style: Theme.of(context).textTheme.titleMedium),
                  sizedBoxH10(context),
                  Text(
                    "  9 dats ago",
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    softWrap: true,
                  ),
                  sizedBoxH10(context),
                  Row(
                    children: [
                      Image.asset(
                        "lib/assets/images/profile.png",
                        scale: 6,
                      ),
                      sizedBoxW5(context),
                      Text(
                        "Anil Yadav",
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        softWrap: true,
                      ),
                      const Spacer(),
                      Icon(
                        MyTabIcons.bookmark,
                        size: 20,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      Icon(
                        Icons.more_vert_rounded,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}
