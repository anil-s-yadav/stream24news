part of 'homepage_bloc.dart';

abstract class HomepageEvent extends Equatable {}

final class HomepageLoadChannelsEvent extends HomepageEvent {
  final String region;
  final String lang;
  HomepageLoadChannelsEvent({required this.region, required this.lang});
  @override
  List<Object?> get props => [region, lang];
}

final class HomepageLoadTrendingEvent extends HomepageEvent {
  final String region;
  final String lang;
  HomepageLoadTrendingEvent({required this.region, required this.lang});
  @override
  List<Object?> get props => [region, lang];
}

final class HomepageLoadRecommendedEvent extends HomepageEvent {
  final String region;
  final String lang;
  HomepageLoadRecommendedEvent({required this.region, required this.lang});
  @override
  List<Object?> get props => [region, lang];
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

// class HomepageUpdateSavedDataEvent extends HomepageEvent {
//   final List<Article> articles;
//   final List<LiveChannelModel> channels;

//   HomepageUpdateSavedDataEvent({
//     required this.articles,
//     required this.channels,
//   });

//   @override
//   List<Object?> get props => [articles, channels];
// }
