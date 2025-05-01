part of 'homepage_bloc.dart';

abstract class HomepageEvent extends Equatable {
  final String region;
  final String lang;
  const HomepageEvent({required this.region, required this.lang});
  @override
  List<Object?> get props => [region, lang];
}

final class HomepageLoadChannelsEvent extends HomepageEvent {
  const HomepageLoadChannelsEvent({required super.region, required super.lang});
}

final class HomepageLoadTrendingEvent extends HomepageEvent {
  const HomepageLoadTrendingEvent({required super.region, required super.lang});
}

final class HomepageLoadRecommendedEvent extends HomepageEvent {
  const HomepageLoadRecommendedEvent(
      {required super.region, required super.lang});
}

final class HomepageLoadSavedDataEvent extends HomepageEvent {
  const HomepageLoadSavedDataEvent(
      {required super.region, required super.lang});
}
