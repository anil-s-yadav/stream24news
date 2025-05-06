import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream24news/features/bookmark/bloc/bookmark_bloc.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../dashboard/homepage/bloc/homepage_bloc.dart';
import '../../dashboard/livetvpage/video_play_screen.dart';
import '../../models/live_channel_model.dart';
import '../../utils/services/my_methods.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Fire initial load only after first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BookmarkBloc>().add(LoadSavedArticlesEvent());
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging || !mounted) return;

    final bloc = context.read<BookmarkBloc>();

    if (_tabController.index == 0) {
      bloc.add(LoadSavedArticlesEvent());
    } else {
      bloc.add(LoadSavedChannelsEvent());
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<HomepageBloc>().add(HomepageLoadSavedDataEvent());
        return true;
      },
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Bookmark"),
            bottom: TabBar(
              labelPadding: const EdgeInsets.all(15),
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              tabs: const [
                Text("Articals"),
                Text("Channels"),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: TabBarView(
              controller: _tabController,
              children: [
                BlocBuilder<BookmarkBloc, BookmarkState>(
                  // bloc: _bookmarkBloc,
                  buildWhen: (previous, current) =>
                      current is BookmarkInitial ||
                      current is BookmarkArticleLoading ||
                      current is BookmarkArticleSuccess ||
                      current is BookmarkArticleError,
                  builder: (context, state) {
                    if (state is BookmarkArticleSuccess) {
                      if (state.savedArticles.isNotEmpty) {
                        return articalsSuccess(state.savedArticles);
                      } else {
                        return savedEmpty();
                      }
                    } else if (state is BookmarkInitial ||
                        state is BookmarkArticleLoading) {
                      return articalLoading();
                    } else if (state is BookmarkArticleError) {
                      // return savedErrorStateWidget(context);
                      return const Center(
                        child: Text("Error loading articles"),
                      );
                    } else {
                      // return savedErrorStateWidget(context);
                      return SizedBox.shrink();
                    }
                  },
                ),
                BlocBuilder<BookmarkBloc, BookmarkState>(
                  // bloc: _bookmarkBloc,
                  buildWhen: (previous, current) =>
                      current is BookmarkInitial ||
                      current is BookmarkChannelLoading ||
                      current is BookmarkChannelSuccess ||
                      current is BookmarkChannelError,
                  builder: (context, state) {
                    if (state is BookmarkChannelSuccess) {
                      if (state.savedChannels.isNotEmpty) {
                        return channelsSuccess(state.savedChannels);
                      } else {
                        return savedEmpty();
                      }
                    } else if (state is BookmarkInitial ||
                        state is BookmarkChannelLoading) {
                      return channelLoading();
                    } else if (state is BookmarkChannelError) {
                      return savedEmpty();
                    } else {
                      return SizedBox.shrink();
                      // return savedErrorStateWidget(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget articalsSuccess(List<Article> savedArticles) {
    return SizedBox(
        child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: min(savedArticles.length, 10),
      itemBuilder: (BuildContext context, int index) {
        String date = getTimeAgo(savedArticles[index].pubDate);
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
                  imageUrl: savedArticles[index].imageUrl ?? defaultImageUrl,
                  height: 80,
                  width: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      savedArticles[index].title ?? "",
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (savedArticles[index].source?.sourceIcon != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              savedArticles[index].source!.sourceIcon!,
                              height: 18,
                              width: 18,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(),
                            ),
                          ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            savedArticles[index].source?.sourceName ?? "Source",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                        PopupMenuButton<int>(
                          icon: Icon(
                            Icons.more_vert_outlined,
                            size: 24,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Text("Delete"),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 1) {
                              context.read<BookmarkBloc>().add(
                                  DeleteSavedArticleEvent(
                                      articleId:
                                          savedArticles[index].articleId ??
                                              ""));
                              BookmarkBloc().add(LoadSavedArticlesEvent());
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ));
  }

  Widget channelsSuccess(
    List<LiveChannelModel> liveChannelModel,
  ) {
    return SizedBox(
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        shrinkWrap: true,
        children: List.generate(
          min(liveChannelModel.length, 9),
          (index) {
            final liveChannel = liveChannelModel[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayScreen(
                        channel: liveChannelModel[index], comingFrom: ""),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Stack(children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: CachedNetworkImage(
                            imageUrl: liveChannel.logo,
                            fit: BoxFit.fitHeight,
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
                        sizedBoxH5(context),
                        Text(
                          liveChannel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -15,
                    child: PopupMenuButton<int>(
                      icon: Icon(
                        Icons.more_vert_outlined,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Text("Delete"),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 1) {
                          context.read<BookmarkBloc>().add(
                              DeleteSavedChannelEvent(
                                  channelId: liveChannel.channelDocId));
                          BookmarkBloc().add(LoadSavedChannelsEvent());
                        }
                      },
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget savedEmpty() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.16,
          ),
          Image.asset(
            "lib/assets/images/empty.png",
            scale: 14,
          ),
          sizedBoxH20(context),
          Text(
            "Empty",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          sizedBoxH10(context),
          const Text(
            "You have not saved anything to the collection!",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  // Widget savedLoadingStateWidget(BuildContext context,
  Widget articalLoading() {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          // final article = articals[index];
          return Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surfaceContainerLow,
              ),
              child: ListTile(
                leading: Container(
                  margin: const EdgeInsets.all(5),
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                title: Container(
                  height: 20,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget channelLoading() {
    return SizedBox(
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        shrinkWrap: true,
        children: List.generate(
          9,
          (index) {
            return Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerLow,
              ),
            );
          },
        ),
      ),
    );
  }
}
