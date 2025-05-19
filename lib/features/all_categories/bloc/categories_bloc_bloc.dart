import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/models/new_model.dart';
part 'categories_bloc_event.dart';
part 'categories_bloc_state.dart';

class CategoriesBlocBloc
    extends Bloc<CategoriesBlocEvent, CategoriesBlocState> {
  List<Article> categorywiseNews = [];
  CategoriesBlocBloc() : super(CategoriesBlocInitial()) {
    on<CategoriesDataLoadEvent>(_fetchCategories);
    on<CategoriesAscFilter>(_fetchCateAsc);
    on<CategoriesMostPoFilter>(_mostPopular);
  }

  void _fetchCategories(
      CategoriesDataLoadEvent event, Emitter<CategoriesBlocState> emit) async {
    try {
      emit(CategoriesBlocLoading());
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: event.region)
          .where('language', isEqualTo: event.lang)
          .orderBy("views", descending: true)
          .get();

      categorywiseNews = snapshot.docs
          .map((doc) => Article.fromMap(doc.data()))
          .where((article) =>
              article.category != null &&
              article.category!.contains(event.category)) // Manual filter
          // .take(50)
          .toList();

      emit(CategoriesBlocSuccess(articalModel: categorywiseNews));
    } catch (e) {
      emit(CategoriesBlocError());
    }
  }

  void _fetchCateAsc(
      CategoriesAscFilter event, Emitter<CategoriesBlocState> emit) async {
    try {
      EasyLoading.show();
      emit(CategoriesBlocLoading());

      categorywiseNews.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));

      EasyLoading.dismiss();
      emit(CategoriesBlocSuccess(articalModel: categorywiseNews));
    } catch (e) {
      EasyLoading.dismiss();
      emit(CategoriesBlocError());
    }
  }

  void _mostPopular(
      CategoriesMostPoFilter event, Emitter<CategoriesBlocState> emit) async {
    try {
      EasyLoading.show();
      emit(CategoriesBlocLoading());

      categorywiseNews.sort((a, b) => (a.views ?? 0).compareTo(b.views ?? 0));

      EasyLoading.dismiss();
      emit(CategoriesBlocSuccess(articalModel: categorywiseNews));
    } catch (e) {
      EasyLoading.dismiss();
      emit(CategoriesBlocError());
    }
  }
}
