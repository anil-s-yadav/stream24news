import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:stream24news/auth/auth_service.dart';

import '../../../auth/create_account/list_data/country_data.dart';
import '../../../models/live_channel_model.dart';
import '../../../models/new_model.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(HomepageInitialState()) {
    on<HomepageLoadChannelsEvent>(_loadHomePageChannels);
    on<HomepageLoadTrendingEvent>(_loadTrendingNews);
    on<HomepageLoadRecommendedEvent>(_loadRecommendedNews);
    on<HomepageLoadSavedDataEvent>(_loadSavedData);
  }

  void _loadHomePageChannels(
      HomepageLoadChannelsEvent event, Emitter<HomepageState> emit) async {
    try {
      emit(HomepageLiveChannelLoading());
      // String? countryCode = countries.firstWhere(
      //     (country) => country['name'] == event.region,
      //     orElse: () => {})['code'];
      // log('Loading channels for region: ${event.region}');
      final snapshot = await FirebaseFirestore.instance
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS')
          .collection('all_channels')
          .where("region", isEqualTo: event.region)
          .where("language", isEqualTo: "hi")
          .get();

      List<LiveChannelModel> allChannels = snapshot.docs
          .map((doc) => LiveChannelModel.fromJson(doc.data()))
          .toList();
      // Filter by region
      List<LiveChannelModel> regionChannels = allChannels
          .where((channel) => channel.region == event.region)
          .take(9)
          .toList();
      // Sort by viewCount (highest first)
      // regionChannels.sort((a, b) => b.viewCount.compareTo(a.viewCount));
      log('Category region Fetch Channel Countory Code: ${event.region}');
      log('Category region Fetch Channel: ${event.region}');
      log('Category lang Fetch Channel: ${event.lang}');
      log('Channels loaded: ${regionChannels.length}');
      emit(HomepageLiveChannelSuccess(liveChannelModel: regionChannels));
    } catch (e) {
      emit(HomepageLiveChannelError());
      throw Exception(e);
    }
  }

  void _loadTrendingNews(
      HomepageLoadTrendingEvent event, Emitter<HomepageState> emit) async {
    try {
      emit(HomepageTrendingNewsLoading());
      // String? countryName = countries.firstWhere(
      //     (country) => country['code'] == event.region,
      //     orElse: () => {})['name'];
      // Only fetch documents where 'country' array contains the target region
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: event.region)
          .where('language', isEqualTo: event.lang)
          .get();

      List<Article> allNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      // Sort by views (highest first)
      allNews.sort((a, b) => (b.views ?? 0).compareTo(a.views ?? 0));

      // Take top 50
      List<Article> trendingNews = allNews.take(50).toList();

      log('Trending news loaded: ${trendingNews.length}');
      emit(HomepageTrendingNewsSuccess(trendingNews));
    } catch (e) {
      emit(HomepageTrendingNewsError());
      throw Exception(e);
    }
  }

  void _loadRecommendedNews(
      HomepageLoadRecommendedEvent event, Emitter<HomepageState> emit) async {
    try {
      emit(HomepageRecommendedNewsLoading());

      // String? countryName = countries.firstWhere(
      //     (country) => country['code'] == event.region,
      //     orElse: () => {})['name'];

      // Only fetch documents where 'country' array contains the target region
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: event.region)
          .where('language', isEqualTo: event.lang)
          .get();

      List<Article> allNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      // Sort by views (highest first)
      allNews.sort((a, b) => (b.views ?? 0).compareTo(a.views ?? 0));

      // Take top 50
      List<Article> recommendedNews = allNews.take(50).toList();

      log('Trending news loaded: ${recommendedNews.length}');
      log('Recommended news loaded: ${recommendedNews.length}');
      emit(HomepageRecommendedNewsSuccess(recommendedNews));
    } catch (e) {
      emit(HomepageRecommendedNewsError());
      throw Exception(e);
    }
  }

  void _loadSavedData(
      HomepageLoadSavedDataEvent event, Emitter<HomepageState> emit) async {
    String userId;
    try {
      emit(HomepageSavedDataLoading());

      if (AuthService().isUserLoggedIn()) {
        userId = AuthService().getUser()!.uid;
      } else {
        emit(HomepageSavedDataError());
        return;
      }

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Step 1: Get all saved channel IDs for the user
      final savedChannelsSnapshot = await firestore
          .collection('user')
          .doc(userId)
          .collection('saved_channels')
          .get();

      List<LiveChannelModel> savedChannels = [];

      for (var doc in savedChannelsSnapshot.docs) {
        final channelId = doc.id;

        // Step 2: Fetch channel details from all_channels using the ID
        final channelDoc = await firestore
            .collection('live_channels')
            .doc('6Kc57CnXtYzg85cD0FXS') // your hardcoded or known document ID
            .collection('all_channels')
            .doc(channelId)
            .get();

        if (channelDoc.exists) {
          savedChannels.add(LiveChannelModel.fromJson(channelDoc.data()!));
        }
      }

      // Step 3: Get all saved article IDs for the user
      final savedArticlesSnapshot = await firestore
          .collection('user')
          .doc(userId)
          .collection('saved_articles')
          .get();
      List<Article> savedArticles = [];
      for (var doc in savedArticlesSnapshot.docs) {
        final articleId = doc.id;

        // Step 4: Fetch article details from news using the ID
        final articleDoc =
            await firestore.collection('news').doc(articleId).get();

        if (articleDoc.exists) {
          savedArticles.add(Article.fromMap(articleDoc.data()!));
        }
      }
      emit(HomepageSavedDataSuccess(
          articles: savedArticles, channels: savedChannels));
    } catch (e) {
      emit(HomepageRecommendedNewsError());
      throw Exception(e);
    }
  }
}
