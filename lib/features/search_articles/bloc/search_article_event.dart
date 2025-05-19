part of 'search_article_bloc.dart';

abstract class SearchArticleEvent extends Equatable {}

class SearchArticle extends SearchArticleEvent {
  final String key;
  SearchArticle({required this.key});
  @override
  List<Object?> get props => [];
}
