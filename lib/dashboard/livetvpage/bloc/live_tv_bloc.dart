import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../auth/auth_service.dart';
import '../../../auth/create_account/list_data/language_data.dart';
import '../../../models/live_channel_model.dart';
import '../../../utils/services/firestore_cache_service.dart';
import '../../../utils/services/shared_pref_service.dart';

part 'live_tv_event.dart';
part 'live_tv_state.dart';

class LiveTvBloc extends Bloc<LiveTvEvent, LiveTvState> {
  List<LiveChannelModel> _allChannels = [];
  List<LiveChannelModel> finalList = [];
  List<LiveChannelModel> displayedChannels = [];

  void _emitSuccess(
      Emitter<LiveTvState> emit, List<LiveChannelModel> channels) {
    displayedChannels = channels;
    emit(LiveTvSuccessState(liveChannelModel: channels));
  }
  LiveTvBloc() : super(LiveTvInitialState()) {
    on<LiveTvDataLoadEvent>(_loadAllChennels);
    on<LiveChannelSaveEvent>(_saveChannel);
    on<LiveChannelReportEvent>(_reportChannel);
    on<LoadRelatedChannelEvent>(_loadRelatedChannels);
    on<LiveChannelFilter>(_filterChannels);
    on<LiveChannelFilterLang>(_filterLang);
    on<LiveChannelSearch>(_searchChannel);
  }

  Future<List<LiveChannelModel>> _getAllChannels() async {
    if (_allChannels.isNotEmpty) {
      return _allChannels;
    }
    final snapshot = await FirestoreCacheService().getQueryWithCache(
      query: FirebaseFirestore.instance
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS')
          .collection('all_channels'),
      cacheKey: 'all_channels',
      ttl: FirestoreCacheService.channelsTtl,
    );
    _allChannels = snapshot.docs
        .map((doc) => LiveChannelModel.fromFirestore(doc))
        .toList();
    return _allChannels;
  }

  void _loadAllChennels(
      LiveTvDataLoadEvent event, Emitter<LiveTvState> emit) async {
    emit(LiveTvLoadingState());

    try {
      final region = SharedPrefService().getCounty()![2];

      final allChannels = await _getAllChannels();

      String selectedRegion = region.toLowerCase(); // "in", "us", etc.

      List<LiveChannelModel> hindi = [];
      List<LiveChannelModel> english = [];
      List<LiveChannelModel> otherIndian = [];
      List<LiveChannelModel> international = [];

      for (var channel in allChannels) {
        if (channel.region.toLowerCase() == selectedRegion) {
          // Handle India's special case
          if (selectedRegion == "in") {
            String lang = channel.language.toLowerCase();
            if (lang.contains("hi") || lang.contains("hindi")) {
              hindi.add(channel);
            } else if (lang.contains("en") || lang.contains("english")) {
              english.add(channel);
            } else {
              otherIndian.add(channel);
            }
          } else {
            hindi.add(channel); // Put all same-country in one group
          }
        } else {
          international.add(channel);
        }
      }

      finalList = [
        ...hindi,
        ...english,
        ...otherIndian,
        ...international,
      ];

      _emitSuccess(emit, finalList);
    } catch (e) {
      emit(LiveTvErrorState());
      throw Exception(e);
    }
  }

  void _filterChannels(
      LiveChannelFilter event, Emitter<LiveTvState> emit) async {
    emit(LiveTvLoadingState());
    try {
      EasyLoading.show();
      if (event.filterValue == "A - Z") {
        finalList.sort((a, b) => (a.name).compareTo(b.name));
      } else if (event.filterValue == "Z - A") {
        finalList.sort((a, b) => (b.name).compareTo(a.name));
      } else if (event.filterValue == "Newest First") {
        finalList.sort((a, b) => (a.viewedAt).compareTo(b.viewedAt));
      } else if (event.filterValue == "Oldest First") {
        finalList.sort((a, b) => (b.viewedAt).compareTo(a.viewedAt));
      } else if (event.filterValue == "Most Popular") {
        finalList.sort((a, b) => (a.viewCount).compareTo(b.viewCount));
      }
      EasyLoading.dismiss();
      _emitSuccess(emit, finalList);
    } catch (e) {
      EasyLoading.dismiss();
      emit(LiveTvErrorState());
      throw Exception(e);
    }
  }

  void _filterLang(
      LiveChannelFilterLang event, Emitter<LiveTvState> emit) async {
    emit(LiveTvLoadingState());
    String langCode = languages[event.lang] ?? "hi";

    try {
      EasyLoading.show();

      final allChannels = await _getAllChannels();
      finalList = allChannels
          .where((channel) => channel.language.toLowerCase() == langCode)
          .toList();
      EasyLoading.dismiss();
      _emitSuccess(emit, finalList);
    } catch (e) {
      EasyLoading.dismiss();
      emit(LiveTvErrorState());
      throw Exception(e);
    }
  }

  void _searchChannel(
      LiveChannelSearch event, Emitter<LiveTvState> emit) async {
    emit(LiveTvLoadingState());

    try {
      if (finalList.isEmpty) {
        finalList = List<LiveChannelModel>.from(await _getAllChannels());
      }

      String query = event.key.trim().toLowerCase();
      List<LiveChannelModel> filteredChannels = finalList.where((channel) {
        return channel.name.toLowerCase().contains(query);
      }).toList();

      _emitSuccess(emit, filteredChannels);
    } catch (e) {
      emit(LiveTvErrorState());
      throw Exception(e);
    }
  }

  void _saveChannel(LiveChannelSaveEvent event, _) async {
    String userId;
    try {
      if (AuthService().isUserLoggedIn()) {
        userId = AuthService().getUser()!.uid;
      } else {
        EasyLoading.showInfo("Please login to save!");
        return;
      }
      EasyLoading.show(status: 'Saving channel...');

      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('saved_channels')
          .doc(event.channelID)
          .set({}); // You can store additional data if needed, like timestamp
      await FirestoreCacheService().invalidate('saved_channels_$userId');
      await FirestoreCacheService()
          .invalidate('homepage_saved_channels_$userId');
      EasyLoading.showSuccess('Channel saved successfully!');
    } catch (e) {
      EasyLoading.showError('Failed to save channel!');
      throw Exception(e);
    }
  }

  void _reportChannel(LiveChannelReportEvent event, _) async {
    String userId;
    try {
      if (AuthService().isUserLoggedIn()) {
        userId = AuthService().getUser()!.uid;
      } else {
        EasyLoading.showInfo("Please login to save!");
        return;
      }
      EasyLoading.show(status: 'Saving channel...');

      await FirebaseFirestore.instance
          .collection('live_chennels')
          .doc("6Kc57CnXtYzg85cD0FXS")
          .collection('reported_channels')
          .doc(event.channelID)
          .set({
        "channels_id": event.channelID,
        "reported_by": userId,
        "comment": event.comment
      });
      EasyLoading.showSuccess("Channel reported!");
    } catch (e) {
      EasyLoading.showError('Failed to save channel!');
      throw Exception(e);
    }
  }

  void _loadRelatedChannels(
      LoadRelatedChannelEvent event, Emitter<LiveTvState> emit) async {
    emit(LoadRelatedChannelLoading());
    try {
      final allChannels = await _getAllChannels();

      List<LiveChannelModel> languageChannels = [];

      for (var channel in allChannels) {
        if ((channel.language) == event.language) {
          languageChannels.add(channel);
        }
      }
      List<LiveChannelModel> finalList = [...languageChannels];

      emit(LoadRelatedChannelSuccess(liveChannelModel: finalList));
    } catch (e) {
      emit(LoadRelatedChannelError());
      throw Exception(e);
    }
  }
}
