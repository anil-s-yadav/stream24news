import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:stream24news/dashboard/newspage/artical_page_design.dart';
import 'package:stream24news/dashboard/newspage/bloc/newspage_bloc.dart';

class Newspage extends StatefulWidget {
  const Newspage({super.key});

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NewspageBloc>(context).add(NewspageLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<NewspageBloc, NewspageState>(
          builder: (context, state) {
            if (state is NewspageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewspageSuccess) {
              final articles = state.articles;
              return Stack(alignment: Alignment.topCenter, children: [
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  // itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final test_article =
                        articles[index % articles.length]; // Looping
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }

                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              child:
                                  // ArticlePageDesign(article: articles[index]),
                                  ArticlePageDesign(article: test_article),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                ),
                Positioned(
                  top: 15,
                  left: MediaQuery.of(context).size.width * 0.25,
                  right: MediaQuery.of(context).size.width * 0.25,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerLow
                          .withOpacity(0.5),
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
                ),
              ]);

              //  return Stack(
              //   alignment: Alignment.topCenter,
              //   children: [
              //     PageView.builder(
              //       controller: _pageController,
              //       scrollDirection: Axis.vertical,
              //       physics: const PageScrollPhysics(), // For smooth snapping
              //       itemCount: articles.length,
              //       onPageChanged: (index) {
              //         setState(() => _currentPage = index);
              //       },
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.symmetric(
              //               vertical: 10, horizontal: 8),
              //           child: ArticlePageDesign(article: articles[index]),
              //         );
              //       },
              //     ),

              //     if (_currentPage == 0)
              //       Positioned(
              //         bottom: 20,
              //         child: Lottie.asset(
              //           'lib/assets/lottie_json/scrollphone.json',
              //           width: 60,
              //           height: 60,
              //           repeat: true,
              //         ),
              //       ),

              //     // Trending label
              //     Positioned(
              //       top: 5,
              //       left: MediaQuery.of(context).size.width * 0.25,
              //       right: MediaQuery.of(context).size.width * 0.25,
              //       child: Container(
              //         height: 30,
              //         decoration: BoxDecoration(
              //           color: Theme.of(context)
              //               .colorScheme
              //               .surfaceContainerLow
              //               .withOpacity(0.5),
              //           borderRadius: BorderRadius.circular(50),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const Text("Trending",
              //                 style: TextStyle(fontWeight: FontWeight.bold)),
              //             Icon(Icons.arrow_drop_down_rounded,
              //                 size: 24,
              //                 color: Theme.of(context).colorScheme.primary),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ],
              // );
            } else {
              return const Center(child: Text("Data not found"));
            }
          },
        ),
      ),
    );
  }
}













// class Newspage extends StatefulWidget {
//   const Newspage({super.key});

//   @override
//   State<Newspage> createState() => _NewspageState();
// }

// class _NewspageState extends State<Newspage> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<NewspageBloc>(context).add(NewspageLoadEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: BlocBuilder<NewspageBloc, NewspageState>(
//           builder: (context, state) {
//             if (state is NewspageLoading) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is NewspageSuccess) {
//               final articles = state.articles;

//               return Stack(
//                 children: [
//                   NotificationListener<ScrollNotification>(
//                     onNotification: (_) {
//                       setState(() {}); // Trigger rebuild for scaling effect
//                       return false;
//                     },
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.symmetric(vertical: 40),
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: articles.length,
//                       itemBuilder: (context, index) {
//                         final itemPositionOffset =
//                             index * 320.0; // approx item height
//                         final difference = _scrollController.hasClients
//                             ? _scrollController.offset - itemPositionOffset
//                             : 0.0;

//                         final percent =
//                             1.0 - (difference / 320.0).clamp(0.0, 1.0);
//                         final scale = 0.9 + (percent * 0.1);
//                         final opacity = (percent).clamp(0.5, 1.0);

//                         return Transform.scale(
//                           scale: scale,
//                           alignment: Alignment.topCenter,
//                           child: Opacity(
//                             opacity: opacity,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12.0, vertical: 8.0),
//                               child:
//                                   ArticlePageDesign(article: articles[index]),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),

//                   // Swipe up animation
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: Lottie.asset(
//                         'lib/assets/lottie_json/scrollphone.json',
//                         width: 60,
//                         height: 60,
//                         repeat: true,
//                       ),
//                     ),
//                   ),

//                   // Trending label
//                   Positioned(
//                     top: 5,
//                     left: MediaQuery.of(context).size.width * 0.25,
//                     right: MediaQuery.of(context).size.width * 0.25,
//                     child: Container(
//                       height: 30,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context)
//                             .colorScheme
//                             .surfaceContainerLow
//                             .withOpacity(0.5),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text("Trending",
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           Icon(Icons.arrow_drop_down_rounded,
//                               size: 24,
//                               color: Theme.of(context).colorScheme.primary),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return const Center(child: Text("Data not found"));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }



/*
class Newspage extends StatefulWidget {
  const Newspage({super.key});

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NewspageBloc>(context).add(NewspageLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<NewspageBloc, NewspageState>(
          builder: (context, state) {
            if (state is NewspageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewspageSuccess) {
              final articles = state.articles;
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: articles.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      final scale = index == _currentPage ? 1.0 : 0.95;
                      final opacity = index == _currentPage ? 1.0 : 0.6;

                      return Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ArticlePageDesign(article: articles[index]),
                          ),
                        ),
                      );
                    },
                  ),

                  if (_currentPage == 0)
                    Positioned(
                      bottom: 20,
                      child: Lottie.asset(
                        'assets/animations/swipe_up.json', // Use your animation here
                        width: 60,
                        height: 60,
                        repeat: true,
                      ),
                    ),

                  // Trending label
                  Positioned(
                    top: 5,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 80),
                      height: 30,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerLow
                            .withOpacity(0.5),
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
                  ),
                ],
              );
            } else {
              return const Center(child: Text("Data not found"));
            }
          },
        ),
      ),
    );
  }
}

*/


/*
class Newspage extends StatefulWidget {
  const Newspage({super.key});

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NewspageBloc>(context).add(NewspageLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Expanded(
              child: BlocBuilder<NewspageBloc, NewspageState>(
                builder: (context, state) {
                  if (state is NewspageSuccess) {
                    log("NewspageSuccess: ${state.articles.length}");
                    if (state.articles.isEmpty) {
                      return Center(child: Text("No articles found"));
                    }
                    return PageView.builder(
                      scrollDirection: Axis.vertical,
                      controller: _pageController,
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        return ArticlePageDesign(
                          article: state.articles[index],
                        );
                      },
                    );
                  } else if (state is NewspageLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text("Data not found"));
                  }
                },
              ),
            ),
            Positioned(
              top: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 80),
                height: 30,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerLow
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Trending",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 24,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/