import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/live_channel_model.dart';

part 'live_tv_event.dart';
part 'live_tv_state.dart';

class LiveTvBloc extends Bloc<LiveTvEvent, LiveTvState> {
  LiveTvBloc() : super(LiveTvInitialState()) {
    on<LiveTvDataLoadEvent>(_loadAllChennels);
  }

  void _loadAllChennels(
      LiveTvDataLoadEvent event, Emitter<LiveTvState> emit) async {
    emit(LiveTvInitialState());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS')
          .collection('all_channels')
          .get();

      List<LiveChannelModel> allChannels = snapshot.docs
          .map((doc) => LiveChannelModel.fromJson(doc.data()))
          .toList();

      // Region code from the event
      String selectedRegion = event.resion;

      // Split into matching region and others
      List<LiveChannelModel> regionChannels = [];
      List<LiveChannelModel> otherChannels = [];

      for (var channel in allChannels) {
        if ((channel.region) == selectedRegion) {
          regionChannels.add(channel);
        } else {
          otherChannels.add(channel);
        }
      }
      // Combine with selected region on top
      List<LiveChannelModel> finalList = [...regionChannels, ...otherChannels];
      // log('$regionChannels');
      // log('$otherChannels');
      // log('$finalList');
      emit(LiveTvSuccessState(liveChannelModel: finalList));
    } catch (e) {
      emit(LiveTvErrorState());
      throw Exception(e);
    }
  }
}
