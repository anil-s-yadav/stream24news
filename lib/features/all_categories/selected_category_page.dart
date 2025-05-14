import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream24news/features/all_categories/bloc/categories_bloc_bloc.dart';
import 'package:stream24news/features/article_view/article_view.dart';
import 'package:stream24news/models/new_model.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';
import '../../dashboard/homepage/bloc/homepage_bloc.dart';
import '../../utils/componants/my_methods.dart';
import '../../utils/services/shared_pref_service.dart';
import '../search_page.dart';
import '../web_view/article_webview.dart';

class SelectedCategoryPage extends StatefulWidget {
  final Map<String, dynamic> selectedCategory;

  const SelectedCategoryPage({super.key, required this.selectedCategory});

  @override
  State<SelectedCategoryPage> createState() => _SelectedCategoryPageState();
}

class _SelectedCategoryPageState extends State<SelectedCategoryPage> {
  late CategoriesBlocBloc categoriesBlocBloc;
  String filterTitle = "Most Popular";
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    String category = widget.selectedCategory['title'];
    List<String> region =
        SharedPrefService().getCounty() ?? ["", "India", "in"];
    List<String> lang = SharedPrefService().getLanguage() ?? ["English", "en"];
    categoriesBlocBloc = BlocProvider.of<CategoriesBlocBloc>(context);
    categoriesBlocBloc.add(
      CategoriesDataLoadEvent(
          region: region[1].toLowerCase(),
          lang: lang[0].toLowerCase(),
          category: category),
    );
    // log("Selected region: ${region}");
    // log("Selected lang: ${lang}");
  }

  void filter() {
    if (filterTitle == "Most Popular") {
      categoriesBlocBloc.add(CategoriesAscFilter());

      setState(() {
        filterTitle = "A-Z";
      });
    } else {
      categoriesBlocBloc.add(CategoriesMostPoFilter());
      setState(() {
        filterTitle = "Most Popular";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // log(widget.selectedCategory['image']);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedCategory['title']),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              child: Icon(MyTabIcons.searchh)),
          sizedBoxW20(context)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              width: double.maxFinite,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.selectedCategory['image'],
                    fit: BoxFit.fitWidth,
                  )),
            ),
            sizedBoxH20(context),
            Row(
              children: [
                Text(
                  "Sort by",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Spacer(),
                Text(
                  filterTitle,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                IconButton(
                    onPressed: () => filter(),
                    icon: Icon(
                      Icons.swap_vert,
                      color: Theme.of(context).colorScheme.primary,
                    ))
              ],
            ),
            Expanded(
              child: BlocBuilder<CategoriesBlocBloc, CategoriesBlocState>(
                  builder: (context, state) {
                if (state is CategoriesBlocLoading ||
                    state is CategoriesBlocError ||
                    state is CategoriesBlocInitial) {
                  return categoryInitialAndErrrorState();
                } else if (state is CategoriesBlocSuccess) {
                  if (state.articalModel.isNotEmpty) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.articalModel.length,
                        itemBuilder: (context, index) {
                          return categoryWidgetData(state.articalModel, index);
                        });
                  } else {
                    return noDataWidget(context);
                  }
                } else {
                  return noDataWidget(context);
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget categoryInitialAndErrrorState() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
          );
        });
  }

  Widget categoryWidgetData(List<Article> articalModelList, int index) {
    String? pubDate = getTimeAgo(articalModelList[index].pubDate);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleView(
                      artical: articalModelList, index: index, comeFrom: "C")));
        },
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: CachedNetworkImage(
                      imageUrl:
                          articalModelList[index].imageUrl ?? defaultImageUrl,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Container(
                            color:
                                Theme.of(context).colorScheme.surfaceContainer,
                          ))),
            ),
            sizedBoxW10(context),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Text(articalModelList[index].title ?? "No title",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        softWrap: true,
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  // sizedBoxH10(context),
                  Text(
                    pubDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    softWrap: true,
                  ),
                  // sizedBoxH10(context),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArticleWebview(
                                  link: articalModelList[index]
                                          .source
                                          ?.sourceUrl ??
                                      "")));
                    },
                    child:
                        /* ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // radius: 12,
                          child: CachedNetworkImage(
                              imageUrl:
                                  articalModelList[index].source?.sourceIcon ??
                                      defaultImageUrl,
                              fit: BoxFit.contain,
                              height: 20,
                              width: 20,
                              placeholder: (context, url) => Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                  )),
                        ),
                        title: Text(
                          articalModelList[index].source?.sourceName ??
                              "No source",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          softWrap: true,
                        ),
                        trailing:
                            newsMenuOptions(context, articalModelList[index]),
                      )*/

                        Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          // radius: 12,
                          child: CachedNetworkImage(
                              imageUrl:
                                  articalModelList[index].source?.sourceIcon ??
                                      defaultImageUrl,
                              fit: BoxFit.contain,
                              height: 20,
                              width: 20,
                              placeholder: (context, url) => Container(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainer,
                                  )),
                        ),
                        // Image.asset(
                        //   "lib/assets/images/profile.png",
                        //   scale: 6,
                        // ),
                        sizedBoxW5(context),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                            articalModelList[index].source?.sourceName ??
                                "No source",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            softWrap: true,
                          ),
                        ),
                        const Spacer(),
                        // sizedBoxW5(context),
                        // IconButton(
                        //     onPressed: () {
                        //       context.read<HomepageBloc>().add(
                        //           HomepageSaveArticleEvent(
                        //               articleModel: articalModelList[index]));
                        //     },
                        //     icon: Icon(
                        //       MyTabIcons.bookmark,
                        //       size: 18,
                        //       color: Theme.of(context).colorScheme.outline,
                        //     )),

                        newsMenuOptions(context, articalModelList[index]),
                        // newsMenuOptions(context),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
