part of 'search_article_bloc.dart';

abstract class SearchArticleState extends Equatable {}

final class SearchArticleInitial extends SearchArticleState {
  @override
  List<Object?> get props => [];
}

final class SearchArticleLoading extends SearchArticleState {
  @override
  List<Object?> get props => [];
}

final class SearchArticleSuccess extends SearchArticleState {
  final List<Article> articleList;
  SearchArticleSuccess({required this.articleList});
  @override
  List<Object?> get props => [];
}

final class SearchArticleError extends SearchArticleState {
  @override
  List<Object?> get props => [];
}
