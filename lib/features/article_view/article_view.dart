import 'package:flutter/material.dart';
import 'package:stream24news/dashboard/newspage/newspage.dart';
import 'package:stream24news/models/new_model.dart';

import '../../dashboard/newspage/artical_page_design.dart';

class ArticleView extends StatefulWidget {
  final List<Article> artical;
  final int index;
  final String comeFrom; // T - Latest, R - recomanded, C -  category
  const ArticleView(
      {super.key,
      required this.artical,
      required this.index,
      required this.comeFrom});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final PageController _pageController = PageController();

  String? selectedCategoryTitle = "Select Category";

  @override
  void initState() {
    super.initState();
    _loadLastReadIndex();
  }

  Future<void> _loadLastReadIndex() async {
    int initialPageIndex = widget.index;
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
        body: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: widget.artical.length,
                itemBuilder: (context, index) {
                  return RepaintBoundary(
                    child: AnimatedBuilder(
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
                            child: RepaintBoundary(
                              child: ArticlePageDesign(
                                  article: widget.artical[index],
                                  isTransitioning: isTransitioning,
                                  isArticleView: true),
                            ),
                            // ArticlePageDesign(article: test_article),
                          ),
                        );
                      },
                    ),
                  );
                },
                // onPageChanged: (index) async {},
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Newspage(comeFrom: "F"))),
                    child: Text("For You",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.comeFrom == "F"
                                ? Colors.blue
                                : Colors.white60,
                            fontSize: 12)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Newspage(comeFrom: "T"))),
                    child: Text("Latest",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.comeFrom == "T"
                                ? Colors.blue
                                : Colors.white60,
                            fontSize: 12)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Newspage(comeFrom: "R"))),
                    child: Text("Recomanded",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.comeFrom == "R"
                                ? Colors.blue
                                : Colors.white60,
                            fontSize: 12)),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Newspage(comeFrom: "C"))),
                    child: Text("Select Caterogry",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.comeFrom == "C"
                                ? Colors.blue
                                : Colors.white60,
                            fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
