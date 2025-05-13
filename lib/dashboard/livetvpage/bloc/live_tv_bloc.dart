import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../auth/create_account/list_data/language_data.dart';
import '../../../models/live_channel_model.dart';
import '../../../utils/services/shared_pref_service.dart';

part 'live_tv_event.dart';
part 'live_tv_state.dart';

class LiveTvBloc extends Bloc<LiveTvEvent, LiveTvState> {
  List<LiveChannelModel> finalList = [];
  LiveTvBloc() : super(LiveTvInitialState()) {
    on<LiveTvDataLoadEvent>(_loadAllChennels);
    on<LiveChannelSaveEvent>(_saveChannel);
    on<LoadRelatedChannelEvent>(_loadRelatedChannels);
    on<LiveChannelFilter>(_filterChannels);
    on<LiveChannelFilterLang>(_filterLang);
    on<LiveChannelSearch>(_searchChannel);
  }

  void _loadAllChennels(
      LiveTvDataLoadEvent event, Emitter<LiveTvState> emit) async {
    emit(LiveTvLoadingState());

    try {
      final region = SharedPrefService().getCounty()![2];

      final snapshot = await FirebaseFirestore.instance
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS')
          .collection('all_channels')
          .get();

      List<LiveChannelModel> allChannels = snapshot.docs
          .map((doc) => LiveChannelModel.fromFirestore(doc))
          .toList();

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
            // Other countries (not India)
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

      emit(LiveTvSuccessState(liveChannelModel: finalList));
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
      emit(LiveTvSuccessState(liveChannelModel: finalList));
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
    log(langCode);
    try {
      EasyLoading.show();

      if (finalList.isEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('live_chennels')
            .doc('6Kc57CnXtYzg85cD0FXS')
            .collection('all_channels')
            .where('language', isEqualTo: langCode)
            .get();
        List<LiveChannelModel> allChannels = snapshot.docs
            .map((doc) => LiveChannelModel.fromFirestore(doc))
            .toList();
        EasyLoading.dismiss();
        emit(LiveTvSuccessState(liveChannelModel: allChannels));
      } else {
        finalList = finalList
            .where((channel) => channel.language.toLowerCase() == langCode)
            .toList();
        EasyLoading.dismiss();
        emit(LiveTvSuccessState(liveChannelModel: finalList));
      }
    } catch (e) {
      EasyLoading.dismiss();
      emit(LiveTvErrorState());
      EasyLoading.dismiss();
      throw Exception(e);
    }
  }

  void _searchChannel(
      LiveChannelSearch event, Emitter<LiveTvState> emit) async {
    emit(LiveTvLoadingState());

    try {
      if (finalList.isEmpty) {
        // Fallback if no data is cached
        final snapshot = await FirebaseFirestore.instance
            .collection('live_chennels')
            .doc('6Kc57CnXtYzg85cD0FXS')
            .collection('all_channels')
            .get();

        finalList = snapshot.docs
            .map((doc) => LiveChannelModel.fromFirestore(doc))
            .toList();
      }

      String query = event.key.trim();
      List<LiveChannelModel> filteredChannels = finalList.where((channel) {
        return channel.name.contains(query);
      }).toList();

      emit(LiveTvSuccessState(liveChannelModel: filteredChannels));
    } catch (e) {
      emit(LiveTvErrorState());
      throw Exception(e);
    }
  }

  void _saveChannel(
      LiveChannelSaveEvent event, Emitter<LiveTvState> emit) async {
    try {
      EasyLoading.show(status: 'Saving channel...');
      // if (AuthService().isUserLoggedIn()) {
      //   userId = AuthService().getUser()!.uid;
      // } else {
      //   emit(HomepageSavedDataError());
      //   return;
      // }
      String testUserID = "w5PvxpVRTiWlUmb3GJ8SrYBFA9L2";

      await FirebaseFirestore.instance
          .collection('user')
          .doc(testUserID)
          .collection('saved_channels')
          .doc(event.channelID)
          .set({}); // You can store additional data if needed, like timestamp
      EasyLoading.showSuccess('Channel saved successfully!');
    } catch (e) {
      EasyLoading.showError('Failed to save channel!');
      throw Exception(e);
    }
  }

  void _loadRelatedChannels(
      LoadRelatedChannelEvent event, Emitter<LiveTvState> emit) async {
    emit(LoadRelatedChannelLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS')
          .collection('all_channels')
          .get();

      List<LiveChannelModel> allChannels = snapshot.docs
          .map((doc) => LiveChannelModel.fromFirestore(doc))
          .toList();

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
