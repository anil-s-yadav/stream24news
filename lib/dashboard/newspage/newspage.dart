import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream24news/dashboard/newspage/artical_page_design.dart';
import 'package:stream24news/dashboard/newspage/bloc/newspage_bloc.dart';

import '../../features/all_categories/category_list/categories_list.dart';
import '../../utils/componants/my_methods.dart';
import '../../utils/componants/sizedbox.dart';
import '../../utils/services/shared_pref_service.dart';

class Newspage extends StatefulWidget {
  const Newspage({super.key});

  @override
  State<Newspage> createState() => _NewspageState();
}

class _NewspageState extends State<Newspage> {
  final PageController _pageController = PageController();
  String? selectedCategoryTitle;

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
    return SafeArea(
      child: Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("For You",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 12)),
                      Text("Trending",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white60,
                              fontSize: 12)),
                      Text("Recomanded",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white60,
                              fontSize: 12)),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          hint: Text("Select Category",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white60,
                                  fontSize: 12)),
                          value: selectedCategoryTitle,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategoryTitle = newValue;
                            });
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
                                    color: Colors.white60,
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
              }
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
