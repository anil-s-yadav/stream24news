import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream24news/dashboard/newspage/artical_page_design.dart';
import 'package:stream24news/dashboard/newspage/bloc/newspage_bloc.dart';

import '../../features/all_categories/category_list/categories_list.dart';
import '../../utils/componants/my_methods.dart';
import '../../utils/componants/sizedbox.dart';
import '../../utils/services/shared_pref_service.dart';

class Newspage extends StatefulWidget {
  final String comeFrom;
  const Newspage({super.key, this.comeFrom = ""});

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  final PageController _pageController = PageController();
  String? selectedCategoryTitle;
  Color fColor = Colors.white60;
  Color tColor = Colors.white60;
  Color rColor = Colors.white60;
  Color cColor = Colors.white60;
  late String comeFrom;

  @override
  void initState() {
    super.initState();
    comeFrom = widget.comeFrom;
    // _loadLastReadIndex();
    _setColor();
  }

  // Future<void> _loadLastReadIndex() async {
  //   int initialPageIndex = SharedPrefService().getLastNewsIndex() ?? 0;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_pageController.hasClients) {
  //       _pageController.jumpToPage(initialPageIndex);
  //     }
  //   });
  // }

  _setColor() {
    if (comeFrom == "F") {
      fColor = Colors.blue;
      tColor = Colors.white60;
      rColor = Colors.white60;
      cColor = Colors.white60;
      //to call for you news
      BlocProvider.of<NewspageBloc>(context).add(NewspageLoadEvent());
    } else if (comeFrom == "T") {
      fColor = Colors.white60;
      tColor = Colors.blue;
      rColor = Colors.white60;
      cColor = Colors.white60;
      //to call trending news
      BlocProvider.of<NewspageBloc>(context).add(NewspageTrending());
    } else if (comeFrom == "R") {
      fColor = Colors.white60;
      tColor = Colors.white60;
      rColor = Colors.blue;
      cColor = Colors.white60;
      //to call recomended news
      BlocProvider.of<NewspageBloc>(context).add(NewspageRecomanded());
    } else if (comeFrom == "C") {
      fColor = Colors.white60;
      tColor = Colors.white60;
      rColor = Colors.white60;
      cColor = Colors.blue;
      //to call for selected category news
      BlocProvider.of<NewspageBloc>(context)
          .add(NewspageSelectCategory(category: "All"));
    } else {
      // to call all news
      BlocProvider.of<NewspageBloc>(context).add(NewspageLoadEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: BlocBuilder<NewspageBloc, NewspageState>(
          builder: (context, state) {
            if (state is NewspageInitial || state is NewspageLoading) {
              return shimmer();
            } else if (state is NewspageSuccess) {
              final articles = state.articles;
              return Stack(alignment: Alignment.topCenter, children: [
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
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
                              isArticleView: false,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  // onPageChanged: (index) async {
                  //   // SharedPrefService().setLastNewsIndex(index);
                  //   // if (index == articles.length - 1) {
                  //   //   SharedPrefService().clearLastNewsIndex();
                  //   // }
                  // },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          comeFrom = "F";
                        });
                        _setColor();
                      },
                      child: Text("For You",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: fColor,
                              fontSize: 12)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          comeFrom = "T";
                        });
                        _setColor();
                      },
                      child: Text("Trending",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tColor,
                              fontSize: 12)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          comeFrom = "R";
                        });
                        _setColor();
                      },
                      child: Text("Recomanded",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: rColor,
                              fontSize: 12)),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isDense: true,
                        hint: Text("Select Category",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cColor,
                                fontSize: 12)),
                        value: selectedCategoryTitle,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategoryTitle = newValue;
                            comeFrom = "C";
                          });
                          _setColor();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_pageController.hasClients) {
                              _pageController.jumpToPage(0);
                            }
                          });
                          BlocProvider.of<NewspageBloc>(context).add(
                              NewspageSelectCategory(
                                  category: selectedCategoryTitle ?? "All"));
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['title'],
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset(
                                    category['image']!,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                sizedBoxW5(context),
                                Text(
                                  category['title']!,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (BuildContext context) {
                          return categories.map((category) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                category['title']!,
                                style: TextStyle(
                                  color: cColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList();
                        },
                      ),
                    )
                  ],
                ),
              ]);
            } else {
              return shimmer();
            }
          },
        ),
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
