import 'package:flutter/material.dart';
import 'package:stream24news/models/new_model.dart';

import '../../dashboard/newspage/artical_page_design.dart';

class ArticleView extends StatefulWidget {
  final List<Article> artical;
  final int index;
  const ArticleView({super.key, required this.artical, required this.index});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final PageController _pageController = PageController();

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
    return Scaffold(
      backgroundColor: Colors.black87,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.artical.length,
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
                    article: widget.artical[index],
                    isTransitioning: isTransitioning,
                  ),
                  // ArticlePageDesign(article: test_article),
                ),
              );
            },
          );
        },
        // onPageChanged: (index) async {},
      ),
    );
  }
}
