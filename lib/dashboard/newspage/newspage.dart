import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream24news/dashboard/newspage/artical_page_design.dart';
import 'package:stream24news/dashboard/newspage/bloc/newspage_bloc.dart';

import '../../utils/componants/my_methods.dart';
import '../../utils/services/shared_pref_service.dart';

class Newspage extends StatefulWidget {
  const Newspage({super.key});

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  final PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    _loadLastReadIndex();
    BlocProvider.of<NewspageBloc>(context).add(NewspageLoadEvent());
  }

  Future<void> _loadLastReadIndex() async {
    int initialPageIndex = SharedPrefService().getLastNewsIndex() ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(initialPageIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: BlocBuilder<NewspageBloc, NewspageState>(
        builder: (context, state) {
          if (state is NewspageInitial || state is NewspageLoading) {
            return shimmer();
          } else if (state is NewspageSuccess) {
            final articles = state.articles;
            if (articles.isEmpty) {
              return noDataWidget(context);
            } else {
              return Stack(alignment: Alignment.topCenter, children: [
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    // final test_article =
                    //     articles[index % articles.length]; // Looping
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0, 10);
                        }
                        final isTransitioning = value < 1.0;
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: ArticlePageDesign(
                              article: articles[index],
                              isTransitioning: isTransitioning,
                            ),
                            // ArticlePageDesign(article: test_article),
                          ),
                        );
                      },
                    );
                  },
                  onPageChanged: (index) async {
                    SharedPrefService().setLastNewsIndex(index);

                    if (index == articles.length - 1) {
                      SharedPrefService().clearLastNewsIndex();
                    }
                  },
                ),
                /*    Positioned(
                  top: 215,
                  left: 12,
                  // left: MediaQuery.of(context).size.width * 0.25,
                  // right: MediaQuery.of(context).size.width * 0.25,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      // color: Theme.of(context)
                      //     .colorScheme
                      //     .surfaceContainerLow
                      //     .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Trending",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Icon(Icons.arrow_drop_down_rounded,
                            size: 24,
                            color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                ),*/
              ]);
            }
          } else {
            return shimmer();
          }
        },
      ),
    );
  }

  Widget shimmer() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.surfaceContainer),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.surfaceContainer),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.surfaceContainer),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.surfaceContainer),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.05,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.surfaceContainer),
          ),
        ],
      ),
    );
  }
}
