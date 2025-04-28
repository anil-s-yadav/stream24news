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
  HomepageLiveChannelSuccess({required this.liveChannelModel});
  @override
  List<Object?> get props => [liveChannelModel];
}

final class HomepageLiveChannelError extends HomepageState {
  @override
  List<Object?> get props => [];
}

// For Trending News
final class HomepageTrendingNewsLoading extends HomepageState {
  @override
  List<Object?> get props => [];
}

final class HomepageTrendingNewsSuccess extends HomepageState {
  final List<Article> articles;
  HomepageTrendingNewsSuccess(this.articles);
  @override
  List<Object?> get props => [articles];
}

final class HomepageTrendingNewsError extends HomepageState {
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
