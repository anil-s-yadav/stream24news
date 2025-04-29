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
import '../../utils/services/shared_pref_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _categories = categories;
  List<LiveChannelModel> liveChannelModel = [];
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    List<String> region = SharedPrefService().getCounty() ?? ["", "", "in"];
    final homepageBloc = BlocProvider.of<HomepageBloc>(context);
    homepageBloc.add(
      HomepageLoadChannelsEvent(region: region[2]),
    );
    homepageBloc.add(
      HomepageLoadTrendingEvent(region: region[2]),
    );
    homepageBloc.add(
      HomepageLoadRecommendedEvent(region: region[2]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buldAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleheading(context, "", "", LiveTvPage(),
                  isLiveChannelTitle: true),
              SizedBox(
                  height: 100,
                  child: BlocBuilder<HomepageBloc, HomepageState>(
                      builder: (context, state) {
                    if (state is HomepageInitialState ||
                        state is HomepageLiveChannelLoading ||
                        state is HomepageLiveChannelError) {
                      return _horizontalScrollLiveChannel(
                        liveChannelModel: liveChannelModel,
                        isErrorState: true,
                      );
                    } else if (state is HomepageLiveChannelSuccess) {
                      setState(() {
                        liveChannelModel = state.liveChannelModel ?? [];
                      });
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
              sizedBoxH10(context),
              titleheading(
                context,
                "Trending",
                "See All",
                TrendingPage(
                  previousWidget: 'Trending',
                ),
              ),
              sizedBoxH10(context),
              SizedBox(child: BlocBuilder<HomepageBloc, HomepageState>(
                builder: (context, state) {
                  if (state is HomepageTrendingNewsLoading ||
                      state is HomepageInitialState ||
                      state is HomepageTrendingNewsError) {
                    return trendingPosts(context, isErrorState: true);
                  } else if (state is HomepageTrendingNewsSuccess) {
                    return trendingPosts(context,
                        artical: state.articles, isErrorState: false);
                  } else {
                    return trendingPosts(context, isErrorState: true);
                  }
                },
              )),
              sizedBoxH30(context),
              //Category Card Static only
              categoryCardItem(categories),
              //Category card end
              sizedBoxH30(context),
              titleheading(
                  context,
                  "Recomanded",
                  "See All",
                  TrendingPage(
                    previousWidget: 'Recommended',
                  )),
              sizedBoxH5(context),
              SizedBox(child: BlocBuilder<HomepageBloc, HomepageState>(
                  builder: (context, state) {
                if (state is HomepageRecommendedNewsLoading ||
                    state is HomepageInitialState ||
                    state is HomepageRecommendedNewsError) {
                  return recomendedPosts(context,
                      isErrorState: true, artical: []);
                } else if (state is HomepageRecommendedNewsSuccess) {
                  return recomendedPosts(context, artical: state.articles);
                } else {
                  return recomendedPosts(context,
                      isErrorState: true, artical: []);
                }
              })),
              titleheading(
                context,
                "Saved",
                "See All ",
                BookmarkPage(),
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
                LiveTvPage(),
              ),
              sizedBoxH5(context),
              _gridLiveChannel(
                  liveChannelModel: liveChannelModel, isLoadingState: false),
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
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 5),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
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
                child: Image.network(
                  liveChannelModel[index].logo,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _gridLiveChannel(
      {List<LiveChannelModel>? liveChannelModel, bool isLoadingState = false}) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      shrinkWrap: true,
      children: List.generate(
        liveChannelModel?.length ?? 0,
        (index) {
          return Container(
            height: 250,
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
                    child: Image.network(
                      liveChannelModel?[index].logo ?? "",
                      scale: 1.5,
                      errorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                    )),
                sizedBoxH5(context),
                Text(
                  maxLines: 1,
                  isLoadingState == false ? liveChannelModel![index].name : "",
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
          );
        },
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
        height: MediaQuery.of(context).size.width * 0.7,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: artical?.length ?? 0,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  //height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "lib/assets/images/test_sample1.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                      sizedBoxH5(context),
                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(
                            style: Theme.of(context).textTheme.labelMedium,
                            "You should know how to make web requests in your chosen programming language"),
                      ),
                      sizedBoxH5(context),
                      Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          sizedBoxW5(context),
                          Image.asset(
                            "lib/assets/images/profile.png",
                            scale: 7,
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
                      sizedBoxH5(context)
                    ],
                  ),
                ),
              ],
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
        height: MediaQuery.of(context).size.height * 0.35,
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
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: artical.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceContainer),
              child: ListTile(
                leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      artical[index].imageUrl ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                    )),
                title: Text(
                  "To get started you'll need an API key. They're free while you are in development.",
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 2,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
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
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget titleheading(
      BuildContext context, String text, String seeall, Widget page,
      {bool isLiveChannelTitle = false}) {
    if (isLiveChannelTitle == true) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
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
              context, MaterialPageRoute(builder: (context) => page));
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
