import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/auth/auth_service.dart';

import '../../../auth/create_account/list_data/country_data.dart';
import '../../../models/live_channel_model.dart';
import '../../../models/new_model.dart';
import '../../../utils/services/shared_pref_service.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  List<String> region = SharedPrefService().getCounty() ??
      ["", "india", "in"]; //["flag", "name", "code"]
  List<String> lang =
      SharedPrefService().getLanguage() ?? ["English", "en"]; //["name", "code"]
  HomepageBloc() : super(HomepageInitialState()) {
    on<HomepageLoadChannelsEvent>(_loadHomePageChannels);
    on<HomepageLoadTrendingEvent>(_loadTrendingNews);
    on<HomepageLoadRecommendedEvent>(_loadRecommendedNews);
    on<HomepageLoadSavedDataEvent>(_loadSavedData);
    on<HomepageSaveArticleEvent>(_saveArticle);
    // on<HomepageUpdateSavedDataEvent>(_updateSavedData);
  }

  // void _updateSavedData(
  //     HomepageUpdateSavedDataEvent event, Emitter<HomepageState> emit) async {
  //   try {
  //     emit(HomepageSavedDataSuccess(
  //       articles: event.articles,
  //       channels: event.channels,
  //     ));
  //   } catch (e) {
  //     emit(HomepageLiveChannelError());
  //     throw Exception(e);
  //   }
  // }

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
          .where("region", isEqualTo: region[2])
          // .where("language", isEqualTo: lang[1])
          .orderBy("viewCount", descending: true)
          .limit(20)
          .get();

      List<LiveChannelModel> allChannels = snapshot.docs
          .map((doc) => LiveChannelModel.fromFirestore(doc))
          .toList();

      // log('Category region Fetch Channel Countory Code: ${region[2]}');
      // log('Category region Fetch Channel: ${region[2]}');
      // log('Category lang Fetch Channel: ${region[2]}');
      // log('Channels loaded: ${allChannels.length}');
      emit(HomepageLiveChannelSuccess(liveChannelModel: allChannels));
    } catch (e) {
      emit(HomepageLiveChannelError());
      throw Exception(e);
    }
  }

  void _loadTrendingNews(
      HomepageLoadTrendingEvent event, Emitter<HomepageState> emit) async {
    try {
      emit(HomepageTrendingNewsLoading());
      String country = region[1];
      String language = lang[0].toLowerCase();
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: country)
          .where('language', isEqualTo: language)
          .orderBy("views", descending: true)
          .limit(20)
          .get();

      List<Article> trendingNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

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
      String country = region[1];
      String language = lang[0].toLowerCase();
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: country)
          .where('language', isEqualTo: language)
          .orderBy("views", descending: true)
          .limit(20)
          .get();

      List<Article> recommendedNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      // // Sort by views (highest first)
      // allNews.sort((a, b) => (b.views ?? 0).compareTo(a.views ?? 0));

      // // Take top 50
      // List<Article> recommendedNews = allNews.take(50).toList();

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
    // String userId;
    try {
      emit(HomepageSavedDataLoading());

      // if (AuthService().isUserLoggedIn()) {
      //   userId = AuthService().getUser()!.uid;
      // } else {
      //   emit(HomepageSavedDataError());
      //   return;
      // }
      String testUserID = "w5PvxpVRTiWlUmb3GJ8SrYBFA9L2";
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Step 1: Get all saved channel IDs for the user
      final savedChannelsSnapshot = await firestore
          .collection('user')
          // .doc(userId)
          .doc(testUserID)
          .collection('saved_channels')
          .limit(10)
          .get();

      List<LiveChannelModel> savedChannels = [];

      for (var doc in savedChannelsSnapshot.docs) {
        final channelId = doc.id;

        // Step 2: Fetch channel details from all_channels using the ID
        final channelDoc = await firestore
            .collection('live_chennels')
            .doc('6Kc57CnXtYzg85cD0FXS') // your hardcoded or known document ID
            .collection('all_channels')
            .doc(channelId)
            .get();

        if (channelDoc.exists) {
          savedChannels.add(LiveChannelModel.fromFirestore(channelDoc));
        }
      }

      // Step 3: Get all saved article IDs for the user
      final savedArticlesSnapshot = await firestore
          .collection('user')
          .doc(testUserID)
          .collection('saved_articles')
          .limit(10)
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

  void _saveArticle(
      HomepageSaveArticleEvent event, Emitter<HomepageState> emit) async {
    try {
      EasyLoading.show(status: 'Saving article...');
      // if (AuthService().isUserLoggedIn()) {
      //   userId = AuthService().getUser()!.uid;
      // } else {
      //   emit(HomepageSavedDataError());
      //   return;
      // }
      String testUserID = "w5PvxpVRTiWlUmb3GJ8SrYBFA9L2";
      final article = event.articleModel;

      if (article.articleId == null) {
        EasyLoading.showError('Invalid article ID');
        return;
      }

      await FirebaseFirestore.instance
          .collection('user')
          .doc(testUserID)
          .collection('saved_articles')
          .doc(article.articleId)
          .set(article.toMap());

      EasyLoading.showSuccess('Article saved successfully!');

      // ✅ Get current state and emit updated success state
      final currentState = state;
      if (currentState is HomepageSavedDataSuccess) {
        final updatedArticles = List<Article>.from(currentState.articles)
          ..add(article);

        emit(HomepageSavedDataSuccess(
          articles: updatedArticles,
          channels: currentState.channels,
        ));
      } else {
        // Optional: Load fresh saved data if not already loaded
        add(HomepageLoadSavedDataEvent());
      }
    } catch (e) {
      EasyLoading.showError('Error saving article');
      throw Exception(e);
    }
  }
}
