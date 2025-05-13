part of 'live_tv_bloc.dart';

abstract class LiveTvEvent extends Equatable {}

final class LiveTvDataLoadEvent extends LiveTvEvent {
  @override
  List<Object?> get props => [];
}

final class LiveChannelSaveEvent extends LiveTvEvent {
  final String channelID;
  LiveChannelSaveEvent({required this.channelID});
  @override
  List<Object?> get props => [channelID];
}

final class LoadRelatedChannelEvent extends LiveTvEvent {
  final String language;
  LoadRelatedChannelEvent({required this.language});
  @override
  List<Object?> get props => [language];
}

final class LiveChannelFilter extends LiveTvEvent {
  final String filterValue;
  LiveChannelFilter({required this.filterValue});
  @override
  List<Object?> get props => [filterValue];
}

final class LiveChannelFilterLang extends LiveTvEvent {
  final String lang;
  LiveChannelFilterLang({required this.lang});
  @override
  List<Object?> get props => [lang];
}

final class LiveChannelSearch extends LiveTvEvent {
  final String key;
  LiveChannelSearch({required this.key});
  @override
  List<Object?> get props => [key];
}
