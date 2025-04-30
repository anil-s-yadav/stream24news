import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/dashboard/homepage/bloc/homepage_bloc.dart';
import 'package:stream24news/dashboard/livetvpage/livetvpage.dart';
import 'package:stream24news/models/live_channel_model.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/samplepage.dart';
import 'package:stream24news/utils/componants/my_widgets.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';

import '../../features/all_categories/all_categories.dart';
import '../../features/all_categories/category_list/categories_list.dart';
import '../../features/all_categories/selected_category_page.dart';
import '../../features/bookmark/bookmark_page.dart';
import '../../features/notification/notification.dart';
import '../../features/trending_page/trending_page.dart';
import '../../utils/services/my_methods.dart';
import '../../utils/services/shared_pref_service.dart';

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
  }

  void loadUser() async {
    List<String> region = SharedPrefService().getCounty() ??
        ["", "india", "in"]; //["flag", "name", "code"]
    List<String> lang = SharedPrefService().getLanguage() ??
        ["English", "en"]; //["name", "code"]
    final homepageBloc = BlocProvider.of<HomepageBloc>(context);
    homepageBloc.add(
      HomepageLoadChannelsEvent(
          region: region[2].toLowerCase(), lang: lang[0].toLowerCase()),
    );

    homepageBloc.add(
      HomepageLoadTrendingEvent(
          region: region[1].toLowerCase(), lang: lang[0].toLowerCase()),
    );

    homepageBloc.add(
      HomepageLoadRecommendedEvent(
          region: region[1].toLowerCase(), lang: lang[0].toLowerCase()),
    );
    print("region[1]: ${region[1].toLowerCase()}");
    print("region[2]: ${region[2].toLowerCase()}");
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
              titleheading(context, "", "", () => LiveTvPage(),
                  isLiveChannelTitle: true),
              SizedBox(
                  height: 100,
                  child: BlocBuilder<HomepageBloc, HomepageState>(
                      bloc: _homepageBloc,
                      buildWhen: (previous, current) =>
                          current is HomepageLiveChannelLoading ||
                          current is HomepageLiveChannelSuccess ||
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
                        }
                      })),
              // sizedBoxH10(context),
              titleheading(
                  context,
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
                  context,
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
              sizedBoxH10(context),
              titleheading(
                context,
                "Saved",
                "See All ",
                () => BookmarkPage(),
              ),
              sizedBoxH5(context),
              Row(
                children: [
                  savedPosts(context),
                  savedPosts(context),
                ],
              ),
              sizedBoxH20(context),
              titleheading(
                context,
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
                    current is HomepageLiveChannelError,
                builder: (context, state) {
                  if (state is HomepageLiveChannelSuccess) {
                    return _gridLiveChannel(
                      liveChannelModel: state.liveChannelModel ?? [],
                      isLoadingState: false,
                    );
                  } else if (state is HomepageLiveChannelLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return _gridLiveChannel(
                      liveChannelModel: [],
                      isLoadingState:
                          true, // show empty/error placeholder state
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
    return SizedBox(
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 5),
        scrollDirection: Axis.horizontal,
        itemCount: min(liveChannelModel?.length ?? 0, 10),
        itemBuilder: (BuildContext context, int index) {
          if (isErrorState == true || liveChannelModel == null) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                child: CachedNetworkImage(
                  imageUrl: liveChannelModel[index].logo,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            );
          }
        },
      ),
    );
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
          min(liveChannelModel.length, 6),
          (index) {
            return Container(
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
                    radius: 40,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: CachedNetworkImage(
                      imageUrl: liveChannelModel[index].logo,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  sizedBoxH5(context),
                  Text(
                    !isLoadingState ? liveChannelModel[index].name : "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget trendingPosts(BuildContext context,
      {bool isErrorState = false, List<Article>? artical}) {
    if (isErrorState == true) {
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
        height: MediaQuery.of(context).size.height * 0.42,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: artical!.isEmpty ? 2 : min(artical.length, 10),
          itemBuilder: (context, index) {
            String trendingPostedDate = getTimeAgo(artical[index].pubDate);
            return Container(
              margin: const EdgeInsets.only(right: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  sizedBoxH5(context),
                  Text(
                    artical[index].title ?? "",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  // sizedBoxH10(context),
                  // Text(
                  //   trendingPostedDate,
                  //   softWrap: true,
                  //   style: TextStyle(fontSize: 10),
                  // ),
                  // sizedBoxH5(context),
                  // Spacer(),
                  Row(
                    children: [
                      // sizedBoxW5(context),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          artical[index].source?.sourceIcon ?? defaultImageUrl,
                          height: 20,
                          width: 20,
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox();
                          },
                        ),
                      ),
                      sizedBoxW5(context),
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
                      // sizedBoxW5(context),
                      const Spacer(),
                      newsMenuOptions(context)
                    ],
                  ),
                ],
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
          return Container(
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (artical[index].source?.sourceIcon != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                artical[index].source!.sourceIcon!,
                                height: 18,
                                width: 18,
                                errorBuilder: (context, error, stackTrace) =>
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
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                    ),
                          ),
                          const SizedBox(width: 8),
                          newsMenuOptions(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget titleheading(BuildContext context, String text, String seeall,
      Widget Function() pageBuilder,
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

  Widget savedPosts(BuildContext context) {
    return SizedBox(
      height: 140,
      width: MediaQuery.of(context).size.width / 2.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyLightContainer(
            height: 110,
            width: MediaQuery.of(context).size.width / 2.1,
            child: const Text("Datkka"),
          ),
          Row(
            children: [
              sizedBoxW15(context),
              Image.asset(
                "lib/assets/images/profile.png",
                scale: 9,
              ),
              sizedBoxW5(context),
              const Text(
                "Anil Yadav",
                style: TextStyle(fontSize: 10),
                softWrap: true,
              ),
              sizedBoxW5(context),
              const Text(
                "1 day ago",
                softWrap: true,
                style: TextStyle(fontSize: 10),
              ),
              const Spacer(),
              const Icon(
                Icons.more_vert_outlined,
                size: 18,
              )
            ],
          ),
        ],
      ),
    );
  }

  AppBar _buldAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Samplepage()));
        },
        child: Row(
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
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 5),
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationPage()));
              },
              child: const Icon(MyTabIcons.notification)),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookmarkPage()));
            },
            child: const Icon(
              MyTabIcons.bookmark,
              size: 21,
            ),
          ),
        ),
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
