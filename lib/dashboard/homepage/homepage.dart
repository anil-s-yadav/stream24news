import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/dashboard/homepage/bloc/homepage_bloc.dart';
import 'package:stream24news/dashboard/livetvpage/livetvpage.dart';
import 'package:stream24news/dashboard/livetvpage/video_play_screen.dart';
import 'package:stream24news/models/live_channel_model.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../features/all_categories/all_categories.dart';
import '../../features/all_categories/category_list/categories_list.dart';
import '../../features/all_categories/selected_category_page.dart';
import '../../features/article_view/article_view.dart';
import '../../features/bookmark/bookmark_page.dart';
import '../../features/notification/notification.dart';
import '../../features/search_articles/search_page.dart';
import '../../features/trending_page/trending_page.dart';
import '../../features/web_view/article_webview.dart';
import '../../utils/componants/my_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomepageBloc? _homepageBloc;

  final List<Map<String, dynamic>> _categories = categories;
  List<LiveChannelModel> liveChannelModel = [];
  List<Article> trendingNewsModel = [];
  List<Article> recommendedNewsModel = [];
  @override
  void initState() {
    super.initState();
    loadUser();
    checkForUpdate();
  }

  void loadUser() async {
    final homepageBloc = BlocProvider.of<HomepageBloc>(context);
    homepageBloc.add(
      HomepageLoadChannelsEvent(),
    );
    homepageBloc.add(
      HomepageLoadTrendingEvent(),
    );
    homepageBloc.add(
      HomepageLoadRecommendedEvent(),
    );
    homepageBloc.add(
      HomepageLoadSavedDataEvent(),
    );
  }

  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint('In-app update failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buldAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              titleheading("", "", () => LiveTvPage(),
                  isLiveChannelTitle: true),
              SizedBox(
                  height: 100,
                  child: BlocBuilder<HomepageBloc, HomepageState>(
                      bloc: _homepageBloc,
                      buildWhen: (previous, current) =>
                          current is HomepageLiveChannelLoading ||
                          current is HomepageLiveChannelSuccess ||
                          current is HomepageInitialState ||
                          current is HomepageLiveChannelError,
                      builder: (context, state) {
                        if (state is HomepageLiveChannelSuccess) {
                          return _horizontalScrollLiveChannel(
                            liveChannelModel: state.liveChannelModel,
                          );
                        } else {
                          return _horizontalScrollLiveChannel(
                            liveChannelModel: liveChannelModel,
                            isErrorState: true,
                          );
                          // return Text("$state");
                        }
                      })),
              // sizedBoxH10(context),
              titleheading(
                  "Trending",
                  "See All",
                  () => TrendingPage(
                        previousWidget: 'Recommended',
                        model: recommendedNewsModel,
                      )),
              sizedBoxH10(context),
              SizedBox(
                  child: BlocBuilder<HomepageBloc, HomepageState>(
                bloc: _homepageBloc,
                buildWhen: (previous, current) =>
                    current is HomepageTrendingNewsLoading ||
                    current is HomepageTrendingNewsSuccess ||
                    current is HomepageTrendingNewsError,
                builder: (context, trendingState) {
                  if (trendingState is HomepageTrendingNewsSuccess) {
                    trendingNewsModel = trendingState.articles;
                    return trendingPosts(
                      context,
                      artical: trendingState.articles,
                    );
                  } else {
                    return trendingPosts(context,
                        isErrorState: true, artical: []);
                  }
                },
              )),
              sizedBoxH10(context),
              //Category Card Static only
              categoryCardItem(categories),
              //Category card end
              sizedBoxH30(context),
              titleheading(
                  "Recomanded",
                  "See All",
                  () => TrendingPage(
                        previousWidget: 'Recommended',
                        model: recommendedNewsModel,
                      )),
              sizedBoxH5(context),
              SizedBox(
                  child: BlocBuilder<HomepageBloc, HomepageState>(
                      bloc: _homepageBloc,
                      buildWhen: (previous, current) =>
                          current is HomepageRecommendedNewsLoading ||
                          current is HomepageRecommendedNewsSuccess ||
                          current is HomepageRecommendedNewsError,
                      builder: (context, state) {
                        if (state is HomepageRecommendedNewsSuccess) {
                          recommendedNewsModel = state.articles;
                          return recomendedPosts(
                            context,
                            artical: state.articles,
                          );
                        } else {
                          return recomendedPosts(context,
                              artical: [], isErrorState: true);
                        }
                      })),
              sizedBoxH20(context),
              // sizedBoxH5(context),
              BlocBuilder<HomepageBloc, HomepageState>(
                bloc: _homepageBloc,
                buildWhen: (previous, current) =>
                    current is HomepageSavedDataError ||
                    current is HomepageSavedDataLoading ||
                    current is HomepageInitialState ||
                    current is HomepageSavedDataSuccess,
                builder: (context, state) {
                  if (state is HomepageSavedDataSuccess) {
                    return savedPosts(state.articles, state.channels);
                  } else {
                    return savedPosts([], []);
                  }
                },
              ),
              // savedPosts(),
              sizedBoxH20(context),
              titleheading(
                "Live channels",
                "See All ",
                () => LiveTvPage(),
              ),
              sizedBoxH5(context),
              BlocBuilder<HomepageBloc, HomepageState>(
                bloc: _homepageBloc,
                buildWhen: (previous, current) =>
                    current is HomepageLiveChannelLoading ||
                    current is HomepageLiveChannelSuccess ||
                    current is HomepageInitialState ||
                    current is HomepageLiveChannelError,
                builder: (context, state) {
                  if (state is HomepageLiveChannelSuccess) {
                    return _gridLiveChannel(
                      liveChannelModel: state.liveChannelModel ?? [],
                    );
                  } else {
                    return _gridLiveChannel(
                      liveChannelModel: [],
                      isLoadingState: true,
                    );
                  }
                },
              ),
              sizedBoxH30(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _horizontalScrollLiveChannel(
      {List<LiveChannelModel>? liveChannelModel, bool isErrorState = false}) {
    if (isErrorState == true ||
        liveChannelModel == null ||
        liveChannelModel.isEmpty) {
      return SizedBox(
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 5),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                    ));
              }));
    } else {
      return SizedBox(
          child: ListView.builder(
              padding: const EdgeInsets.only(left: 5),
              scrollDirection: Axis.horizontal,
              itemCount: min(liveChannelModel.length, 10),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayScreen(
                              channel: liveChannelModel[index], comingFrom: ""),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: CachedNetworkImage(
                            imageUrl: liveChannelModel[index].logo,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }));
    }
  }

  Widget _gridLiveChannel({
    required List<LiveChannelModel> liveChannelModel,
    bool isLoadingState = false,
  }) {
    return SizedBox(
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        shrinkWrap: true,
        children: List.generate(
          isLoadingState == true ? 6 : min(liveChannelModel.length, 9),
          (index) {
            return GestureDetector(
              onTap: () {
                if (isLoadingState == true) {
                  return;
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayScreen(
                          channel: liveChannelModel[index], comingFrom: ""),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.045,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: isLoadingState == true
                          ? null
                          : CachedNetworkImage(
                              imageUrl: liveChannelModel[index].logo,
                              fit: BoxFit.fitHeight,
                              placeholder: (context, url) => Container(
                                // height: 40,
                                // height:
                                //     MediaQuery.of(context).size.height * 0.02,
                                // width: MediaQuery.of(context).size.width * 0.02,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                    ),
                    sizedBoxH10(context),
                    Text(
                      !isLoadingState ? liveChannelModel[index].name : "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget trendingPosts(BuildContext context,
      {bool isErrorState = false, List<Article>? artical}) {
    if (isErrorState == true || artical!.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.width * 0.7,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          itemBuilder: (context, _) {
            return Container(
              height: MediaQuery.of(context).size.width * 0.7,
              width: MediaQuery.of(context).size.width * 0.5,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.44,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: min(artical.length, 10),
          itemBuilder: (context, index) {
            // String trendingPostedDate = getTimeAgo(artical[index].pubDate);
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArticleView(
                          artical: artical, index: index, comeFrom: "T"))),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                // padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).hoverColor,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: artical[index].imageUrl ?? defaultImageUrl,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitHeight,
                        placeholder: (context, url) => Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    sizedBoxH5(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        artical[index].title ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArticleWebview(
                                    link: artical[index].source?.sourceUrl ??
                                        "")));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          sizedBoxW5(context),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              artical[index].source?.sourceIcon ??
                                  defaultImageUrl,
                              height: 20,
                              width: 20,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox();
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Text(
                              artical[index].source?.sourceName ?? "Source",
                              style: TextStyle(fontSize: 10),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          newsMenuOptions(context, artical[index]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget recomendedPosts(BuildContext context,
      {required List<Article> artical, bool isErrorState = false}) {
    if (isErrorState == true) {
      return SizedBox(
        // height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 5,
          itemBuilder: (BuildContext context, _) {
            return Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
            );
          },
        ),
      );
    } else {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: min(artical.length, 10),
        itemBuilder: (BuildContext context, int index) {
          String date = getTimeAgo(artical[index].pubDate);
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ArticleView(
                        artical: artical, index: index, comeFrom: "R"))),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: artical[index].imageUrl ?? defaultImageUrl,
                      height: 80,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artical[index].title ?? "",
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArticleWebview(
                                        link:
                                            artical[index].source?.sourceUrl ??
                                                "")));
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (artical[index].source?.sourceIcon != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    artical[index].source!.sourceIcon!,
                                    height: 18,
                                    width: 18,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const SizedBox(),
                                  ),
                                ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  artical[index].source?.sourceName ?? "Source",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontSize: 10,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                date,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 10,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              newsMenuOptions(context, artical[index]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget titleheading(String text, String seeall, Widget Function() pageBuilder,
      {bool isLiveChannelTitle = false}) {
    if (isLiveChannelTitle == true) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pageBuilder()),
          );
        },
        child: Row(
          children: [
            sizedBoxW5(context),
            Lottie.asset('lib/assets/lottie_json/livetv_title.json',
                animate: false, height: 15),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: Text(
                "See All  >",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pageBuilder()),
          );
        },
        child: Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: Text(
                seeall,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget savedPosts(
    List<Article> articals,
    List<LiveChannelModel> liveChannelModel,
  ) {
    return articals.isEmpty && liveChannelModel.isEmpty
        ? SizedBox.shrink()
        : Column(
            children: [
              titleheading(
                "Saved",
                "See All",
                () => BookmarkPage(),
              ),
              sizedBoxH5(context),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      liveChannelModel.isEmpty
                          ? SizedBox.shrink()
                          : SizedBox(
                              height: 90,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: min(liveChannelModel.length, 10),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayScreen(
                                            channel: liveChannelModel[index],
                                            comingFrom: ""),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        liveChannelModel[index].logo,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      sizedBoxH5(context),
                      // News cards
                      articals.isEmpty
                          ? SizedBox.shrink()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: min(articals.length, 5),
                              itemBuilder: (context, index) {
                                final article = articals[index];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ArticleView(
                                              artical: articals,
                                              index: index,
                                              comeFrom: "F"))),
                                  child: Container(
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                      ),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: article.imageUrl ??
                                                defaultImageUrl,
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              height: 60,
                                              width: 60,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceContainer,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        title: Text(
                                          article.title ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                );
                              },
                            ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookmarkPage()));
                          },
                          child: const Text("See All saved items"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  AppBar _buldAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            "Stream24 ",
            style: GoogleFonts.dancingScript(fontWeight: FontWeight.bold),
          ),
          Text(
            "News",
            style: GoogleFonts.dancingScript(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SearchPage()));
          },
          icon: const Icon(
            MyTabIcons.searchh,
            size: 21,
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationPage()));
            },
            icon: const Icon(MyTabIcons.notification)),
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const BookmarkPage()));
          },
          icon: const Icon(
            MyTabIcons.bookmark,
            size: 21,
          ),
        ),
        sizedBoxW10(context)
      ],
    );
  }

  Widget categoryCardItem(List<Map<String, dynamic>> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllCategoriesPage()));
          },
          child: Text(
            " See all catogeries    >",
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary, fontSize: 17),
          ),
        ),
        sizedBoxH20(context),

        // Horizontal list of categories
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.15,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectedCategoryPage(
                            selectedCategory: _categories[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  _categories[index]["image"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withAlpha(200),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Spacer(),
                                  Center(
                                    child: Text(
                                      _categories[index]["title"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  sizedBoxH5(context),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
        ),
      ],
    );
  }
}
