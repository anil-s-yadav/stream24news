part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();

  @override
  List<Object> get props => [];
}

class LoadSavedArticlesEvent extends BookmarkEvent {}

class LoadSavedChannelsEvent extends BookmarkEvent {}

class DeleteSavedArticleEvent extends BookmarkEvent {
  final String articleId;

  const DeleteSavedArticleEvent({required this.articleId});

  @override
  List<Object> get props => [articleId];
}

class DeleteSavedChannelEvent extends BookmarkEvent {
  final String channelId;

  const DeleteSavedChannelEvent({required this.channelId});

  @override
  List<Object> get props => [channelId];
}
