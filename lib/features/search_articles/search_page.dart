import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream24news/features/search_articles/bloc/search_article_bloc.dart';

import '../../utils/componants/my_methods.dart';
import '../article_view/article_view.dart';
import '../web_view/article_webview.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
              child: BlocBuilder<SearchArticleBloc, SearchArticleState>(
                  buildWhen: (previous, current) =>
                      current is SearchArticleInitial ||
                      current is SearchArticleLoading ||
                      current is SearchArticleSuccess ||
                      current is SearchArticleError,
                  builder: (context, state) {
                    if (state is SearchArticleInitial) {
                      return SizedBox.shrink();
                    } else if (state is SearchArticleLoading) {
                      return CircularProgressIndicator();
                    } else if (state is SearchArticleError) {
                      return noDataWidget(context);
                    } else if (state is SearchArticleSuccess) {
                      if (state.articleList.isEmpty) {
                        return noDataWidget(context);
                      } else {
                        return ListView.builder(
                          itemCount: state.articleList.length,
                          itemBuilder: (context, index) {
                            final article = state.articleList[index];
                            String date = getTimeAgo(article.pubDate);
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArticleView(
                                          artical: state.articleList,
                                          index: index,
                                          comeFrom: "F"))),
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceContainer,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            article.imageUrl ?? defaultImageUrl,
                                        height: 80,
                                        width: 100,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article.title ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ArticleWebview(
                                                              link: article
                                                                      .source
                                                                      ?.sourceUrl ??
                                                                  "")));
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                if (article
                                                        .source?.sourceIcon !=
                                                    null)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      article
                                                          .source!.sourceIcon!,
                                                      height: 18,
                                                      width: 18,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const SizedBox(),
                                                    ),
                                                  ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    article.source
                                                            ?.sourceName ??
                                                        "Source",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontSize: 10,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  date,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        fontSize: 10,
                                                      ),
                                                ),
                                                const SizedBox(width: 8),
                                                newsMenuOptions(
                                                    context, article),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return Center(child: Text(state.toString()));
                    }
                  })),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      toolbarHeight: MediaQuery.of(context).size.height * 0.080,
      title: Column(
        children: [
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: Colors.black26,
            child: TextField(
              cursorColor: Theme.of(context).colorScheme.secondary,
              decoration: InputDecoration(
                hintText: "Search ",
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: MediaQuery.of(context).size.width * 0.005,
                  ),
                ),
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 400), () {
                  context
                      .read<SearchArticleBloc>()
                      .add(SearchArticle(key: value));
                });
              },
              onSubmitted: (value) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 400), () {
                  context
                      .read<SearchArticleBloc>()
                      .add(SearchArticle(key: value));
                });
              },
            ),
          ),
          // sizedBoxH10(context),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [filter("Language"), filter("Country")],
          // ),
          // sizedBoxH5(context),
        ],
      ),
    );
  }
}
