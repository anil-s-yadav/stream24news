import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:stream24news/models/new_model.dart';

part 'search_article_event.dart';
part 'search_article_state.dart';

class SearchArticleBloc extends Bloc<SearchArticleEvent, SearchArticleState> {
  SearchArticleBloc() : super(SearchArticleInitial()) {
    on<SearchArticle>(_searchArticle);
  }

  void _searchArticle(
      SearchArticle event, Emitter<SearchArticleState> emit) async {
    try {
      emit(SearchArticleLoading());

      // Firestore search with prefix match
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('news')
          .orderBy('title')
          .startAt([event.key]).endAt(['${event.key}\uf8ff']).get();

      // Convert documents to Article objects
      List<Article> articleList = snapshot.docs
          .map((doc) => Article.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      emit(SearchArticleSuccess(articleList: articleList));
    } catch (e) {
      emit(SearchArticleError());
    }
  }
}
