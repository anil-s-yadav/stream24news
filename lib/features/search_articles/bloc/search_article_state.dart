part of 'search_article_bloc.dart';

sealed class SearchArticleState extends Equatable {
  const SearchArticleState();
  
  @override
  List<Object> get props => [];
}

final class SearchArticleInitial extends SearchArticleState {}
