part of 'homepage_bloc.dart';

abstract class HomepageEvent extends Equatable {}

final class HomepageLoadChannelsEvent extends HomepageEvent {
  final String region;
  HomepageLoadChannelsEvent({required this.region});
  @override
  List<Object?> get props => [region];
}

final class HomepageLoadTrendingEvent extends HomepageEvent {
  final String region;
  HomepageLoadTrendingEvent({required this.region});
  @override
  List<Object?> get props => [region];
}
