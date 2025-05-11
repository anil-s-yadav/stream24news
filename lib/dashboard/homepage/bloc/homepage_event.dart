part of 'homepage_bloc.dart';

abstract class HomepageEvent extends Equatable {}

final class HomepageLoadChannelsEvent extends HomepageEvent {
  @override
  List<Object?> get props => [];
}

final class HomepageLoadTrendingEvent extends HomepageEvent {
  @override
  List<Object?> get props => [];
}

final class HomepageLoadRecommendedEvent extends HomepageEvent {
  @override
  List<Object?> get props => [];
}

final class HomepageLoadSavedDataEvent extends HomepageEvent {
  @override
  List<Object?> get props => [];
}

final class HomepageSaveArticleEvent extends HomepageEvent {
  final Article articleModel;
  HomepageSaveArticleEvent({required this.articleModel});
  @override
  List<Object?> get props => [articleModel];
}
