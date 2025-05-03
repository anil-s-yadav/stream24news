import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
