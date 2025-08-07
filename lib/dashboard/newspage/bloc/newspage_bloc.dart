import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';

import '../../../models/new_model.dart';

part 'newspage_event.dart';
part 'newspage_state.dart';

class NewspageBloc extends Bloc<NewspageEvent, NewspageState> {
  List<Article> articles = [];
  List<String> region = SharedPrefService().getCounty() ??
      ["", "india", "in"]; //["flag", "name", "code"]
  List<String> lang =
      SharedPrefService().getLanguage() ?? ["English", "en"]; //["name", "code"]
  NewspageBloc() : super(NewspageInitial()) {
    on<NewspageLoadEvent>(_loadNewspage);
    on<NewspageLatest>(_loadLatest);
    on<NewspageRecomanded>(_loadRecommended);
    on<NewspageSelectCategory>(_loadCategory);
  }

  void _loadNewspage(
      NewspageLoadEvent event, Emitter<NewspageState> emit) async {
    emit(NewspageLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: region[1].toLowerCase())
          .where('language', isEqualTo: lang[0].toLowerCase())
          .get();

      articles =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      if (articles.isNotEmpty) {
        emit(NewspageSuccess(articles: articles));
      } else {
        final snapshot = await FirebaseFirestore.instance
            .collection('news')
            .where('country', arrayContains: region[1].toLowerCase())
            .get();

        articles =
            snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
        if (articles.isNotEmpty) {
          emit(NewspageSuccess(articles: articles));
        } else {
          final snapshot = await FirebaseFirestore.instance
              .collection('news')
              .where('language', isEqualTo: lang[0].toLowerCase())
              .get();

          articles =
              snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
          if (articles.isNotEmpty) {
            emit(NewspageSuccess(articles: articles));
          } else {
            final snapshot = await FirebaseFirestore.instance
                .collection('news')
                .where('country', arrayContains: 'india')
                .where('language', isEqualTo: 'english')
                .get();

            articles = snapshot.docs
                .map((doc) => Article.fromMap(doc.data()))
                .toList();
            emit(NewspageSuccess(articles: articles));
          }
        }
      }
    } catch (e) {
      emit(NewspageError());
    }
  }

  void _loadLatest(NewspageLatest event, Emitter<NewspageState> emit) async {
    emit(NewspageLoading());
    try {
      if (articles.isEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('news')
            .where('country', arrayContains: region[1].toLowerCase())
            .where('language', isEqualTo: lang[0].toLowerCase())
            .get();
        articles =
            snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
      }
      articles.sort((a, b) => (a.views ?? 0).compareTo(b.views ?? 0));

      emit(NewspageSuccess(articles: articles));
    } catch (e) {
      emit(NewspageError());
    }
  }

  void _loadRecommended(
      NewspageRecomanded event, Emitter<NewspageState> emit) async {
    emit(NewspageLoading());
    try {
      if (articles.isEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('news')
            .where('country', arrayContains: region[1].toLowerCase())
            .where('language', isEqualTo: lang[0].toLowerCase())
            .get();
        articles =
            snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
      }
      articles.sort((a, b) => (a.pubDate ?? "").compareTo(b.pubDate ?? ""));

      emit(NewspageSuccess(articles: articles));
    } catch (e) {
      emit(NewspageError());
    }
  }

  void _loadCategory(
      NewspageSelectCategory event, Emitter<NewspageState> emit) async {
    emit(NewspageLoading());
    try {
      if (articles.isEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('news')
            .where('country', arrayContains: region[1].toLowerCase())
            .where('language', isEqualTo: lang[0].toLowerCase())
            .get();
        articles =
            snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
      }

      if (event.category == "All") {
        emit(NewspageSuccess(articles: articles));
      } else {
        final filteredArticles = articles.where((article) {
          return article.category != null &&
              article.category!.contains(event.category.toLowerCase());
        }).toList();
        if (filteredArticles.isNotEmpty) {
          emit(NewspageSuccess(articles: filteredArticles));
        } else {
          emit(NewspageSuccess(articles: articles));
        }
      }
    } catch (e) {
      emit(NewspageError());
    }
  }
}
