part of 'live_tv_bloc.dart';

abstract class LiveTvEvent extends Equatable {}

final class LiveTvDataLoadEvent extends LiveTvEvent {
  final String resion;
  LiveTvDataLoadEvent({required this.resion});
  @override
  List<Object?> get props => [resion];
}

final class LiveChannelSaveEvent extends LiveTvEvent {
  final String channelID;
  LiveChannelSaveEvent({required this.channelID});
  @override
  List<Object?> get props => [channelID];
}
