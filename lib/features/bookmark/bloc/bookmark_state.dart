part of 'bookmark_bloc.dart';

abstract class BookmarkState extends Equatable {}

final class BookmarkInitial extends BookmarkState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

//// States for Load Save Articles
final class BookmarkArticleLoading extends BookmarkState {
  @override
  List<Object?> get props => [];
}

final class BookmarkArticleSuccess extends BookmarkState {
  final List<Article> savedArticles;
  BookmarkArticleSuccess({required this.savedArticles});

  @override
  List<Object?> get props => [savedArticles];
}

final class BookmarkArticleError extends BookmarkState {
  @override
  List<Object?> get props => [];
}

//// States for Save Article
final class BookmarkChannelLoading extends BookmarkState {
  @override
  List<Object?> get props => [];
}

final class BookmarkChannelSuccess extends BookmarkState {
  final List<LiveChannelModel> savedChannels;
  BookmarkChannelSuccess({required this.savedChannels});

  @override
  List<Object?> get props => [savedChannels];
}

final class BookmarkChannelError extends BookmarkState {
  @override
  List<Object?> get props => [];
}
