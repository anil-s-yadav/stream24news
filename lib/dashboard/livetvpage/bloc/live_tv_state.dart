part of 'live_tv_bloc.dart';

sealed class LiveTvState extends Equatable {}

final class LiveTvInitialState extends LiveTvState {
  @override
  List<Object?> get props => [];
}

final class LiveTvLoadingState extends LiveTvState {
  @override
  List<Object?> get props => [];
}

final class LiveTvSuccessState extends LiveTvState {
  final List<LiveChannelModel> liveChannelModel;
  LiveTvSuccessState({required this.liveChannelModel});
  @override
  List<Object?> get props => [liveChannelModel];
}

final class LiveTvErrorState extends LiveTvState {
  @override
  List<Object?> get props => [];
}

//////////////////////////

final class LoadRelatedChannelLoading extends LiveTvState {
  @override
  List<Object?> get props => [];
}

final class LoadRelatedChannelSuccess extends LiveTvState {
  final List<LiveChannelModel> liveChannelModel;
  LoadRelatedChannelSuccess({required this.liveChannelModel});
  @override
  List<Object?> get props => [liveChannelModel];
}

final class LoadRelatedChannelError extends LiveTvState {
  @override
  List<Object?> get props => [];
}
