import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:stream24news/models/new_model.dart';
part 'categories_bloc_event.dart';
part 'categories_bloc_state.dart';

class CategoriesBlocBloc
    extends Bloc<CategoriesBlocEvent, CategoriesBlocState> {
  CategoriesBlocBloc() : super(CategoriesBlocInitial()) {
    on<CategoriesDataLoadEvent>(_fetchCategories);
  }

  void _fetchCategories(
      CategoriesDataLoadEvent event, Emitter<CategoriesBlocState> emit) async {
    try {
      emit(CategoriesBlocLoading());
      // String? countryName = countries.firstWhere(
      //     (country) => country['code'] == event.region,
      //     orElse: () => {})['name'];
      // Only fetch documents where 'country' array contains the target region
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: event.region)
          .where('language', isEqualTo: event.lang)
          .get();

      List<Article> categorywiseNews = snapshot.docs
          .map((doc) => Article.fromMap(doc.data()))
          .take(50)
          .toList();

      // Sort by views (highest first)
      // categorywiseNews.sort((a, b) => (b.views ?? 0).compareTo(a.views ?? 0));

      // Take top 50
      // List<Article> trendingNews = categorywiseNews.take(50).toList();
      log('Category region: ${event.region}');
      log('Category lang: ${event.lang}');

      log('Category news loaded: ${categorywiseNews.length}');
      emit(CategoriesBlocSuccess(articalModel: categorywiseNews));
    } catch (e) {
      emit(CategoriesBlocError());
    }
  }
}
