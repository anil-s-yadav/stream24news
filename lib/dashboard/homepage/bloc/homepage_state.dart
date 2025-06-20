part of 'homepage_bloc.dart';

abstract class HomepageState extends Equatable {}

final class HomepageInitialState extends HomepageState {
  @override
  List<Object?> get props => [];
}

// For Live Channels
final class HomepageLiveChannelLoading extends HomepageState {
  @override
  List<Object?> get props => [];
}

final class HomepageLiveChannelSuccess extends HomepageState {
  final List<LiveChannelModel>? liveChannelModel;
  HomepageLiveChannelSuccess({
    required this.liveChannelModel,
  });
  @override
  List<Object?> get props => [liveChannelModel];
}

final class HomepageLiveChannelError extends HomepageState {
  @override
  List<Object?> get props => [];
}

// For Latest News
final class HomepageLatestNewsLoading extends HomepageState {
  @override
  List<Object?> get props => [];
}

final class HomepageLatestNewsSuccess extends HomepageState {
  final List<Article> articles;
  HomepageLatestNewsSuccess(this.articles);
  @override
  List<Object?> get props => [articles];
}

final class HomepageLatestNewsError extends HomepageState {
  @override
  List<Object?> get props => [];
}

// For Recommended News
final class HomepageRecommendedNewsLoading extends HomepageState {
  @override
  List<Object?> get props => [];
}

final class HomepageRecommendedNewsSuccess extends HomepageState {
  final List<Article> articles;
  HomepageRecommendedNewsSuccess(this.articles);
  @override
  List<Object?> get props => [articles];
}

final class HomepageRecommendedNewsError extends HomepageState {
  @override
  List<Object?> get props => [];
}

// For Saved News and saved Channels
final class HomepageSavedDataLoading extends HomepageState {
  @override
  List<Object?> get props => [];
}

final class HomepageSavedDataSuccess extends HomepageState {
  final List<Article> articles;
  final List<LiveChannelModel> channels;

  HomepageSavedDataSuccess({required this.articles, required this.channels});
  @override
  List<Object?> get props => [articles];
}

final class HomepageSavedDataError extends HomepageState {
  @override
  List<Object?> get props => [];
}
