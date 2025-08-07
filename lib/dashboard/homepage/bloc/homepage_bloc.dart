import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/auth/auth_service.dart';

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
    on<HomepageLoadLatestEvent>(_loadLatestNews);
    on<HomepageLoadRecommendedEvent>(_loadRecommendedNews);
    on<HomepageLoadSavedDataEvent>(_loadSavedData);
    on<HomepageSaveArticleEvent>(_saveArticle);
  }

  void _loadHomePageChannels(
      HomepageLoadChannelsEvent event, Emitter<HomepageState> emit) async {
    try {
      emit(HomepageLiveChannelLoading());

      final snapshot = await FirebaseFirestore.instance
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS')
          .collection('all_channels')
          .where("region", isEqualTo: region[2])
          .orderBy("viewCount", descending: true)
          .limit(20)
          .get();

      List<LiveChannelModel> regionChannels = snapshot.docs
          .map((doc) => LiveChannelModel.fromFirestore(doc))
          .toList();

      if (regionChannels.isEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection('live_chennels')
            .doc('6Kc57CnXtYzg85cD0FXS')
            .collection('all_channels')
            .orderBy("viewCount", descending: true)
            .limit(20)
            .get();

        List<LiveChannelModel> allChannels = snapshot.docs
            .map((doc) => LiveChannelModel.fromFirestore(doc))
            .toList();
        emit(HomepageLiveChannelSuccess(liveChannelModel: allChannels));
      } else {
        emit(HomepageLiveChannelSuccess(liveChannelModel: regionChannels));
      }
    } catch (e) {
      emit(HomepageLiveChannelError());
      throw Exception(e);
    }
  }

  void _loadLatestNews(
      HomepageLoadLatestEvent event, Emitter<HomepageState> emit) async {
    try {
      emit(HomepageLatestNewsLoading());
      List<Article> latestNews;
      final country = region[1].toLowerCase();
      final language = lang[0].toLowerCase();

      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: country)
          .where('language', isEqualTo: language)
          .orderBy('pubDate', descending: true)
          // .limit(20)
          .get();

      latestNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      if (latestNews.isNotEmpty) {
        emit(HomepageLatestNewsSuccess(latestNews));
      } else {
        final snapshot = await FirebaseFirestore.instance
            .collection('news')
            .where('country', arrayContains: country)
            .orderBy('pubDate', descending: true)
            .get();

        latestNews =
            snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
        if (latestNews.isNotEmpty) {
          emit(HomepageLatestNewsSuccess(latestNews));
        } else {
          final snapshot = await FirebaseFirestore.instance
              .collection('news')
              .where('language', isEqualTo: language)
              .orderBy('pubDate', descending: true)
              // .limit(20)
              .get();

          latestNews =
              snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

          if (latestNews.isNotEmpty) {
            emit(HomepageLatestNewsSuccess(latestNews));
          } else {
            final snapshot = await FirebaseFirestore.instance
                .collection('news')
                .where('country', arrayContains: 'india')
                .where('language', isEqualTo: 'english')
                .orderBy('pubDate', descending: true)
                // .limit(20)
                .get();

            latestNews = snapshot.docs
                .map((doc) => Article.fromMap(doc.data()))
                .toList();
            emit(HomepageLatestNewsSuccess(latestNews, noData: true));
          }
        }
      }
      log(latestNews.length.toString());
    } catch (e) {
      emit(HomepageLatestNewsError());
      throw Exception(e);
    }
  }

  void _loadRecommendedNews(
      HomepageLoadRecommendedEvent event, Emitter<HomepageState> emit) async {
    try {
      emit(HomepageRecommendedNewsLoading());
      List<Article> recommendedNews;
      String country = region[1].toLowerCase();
      String language = lang[0].toLowerCase();
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: country)
          .where('language', isEqualTo: language)
          .orderBy("views", descending: true)
          .limit(20)
          .get();

      recommendedNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      if (recommendedNews.isNotEmpty) {
        emit(HomepageRecommendedNewsSuccess(recommendedNews));
      } else {
        final snapshot = await FirebaseFirestore.instance
            .collection('news')
            .where('country', arrayContains: country)
            .orderBy("views", descending: true)
            .limit(20)
            .get();

        recommendedNews =
            snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
        if (recommendedNews.isNotEmpty) {
          emit(HomepageRecommendedNewsSuccess(recommendedNews));
        } else {
          final snapshot = await FirebaseFirestore.instance
              .collection('news')
              .where('language', isEqualTo: 'english')
              .orderBy("views", descending: true)
              .limit(20)
              .get();

          recommendedNews =
              snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
          emit(HomepageRecommendedNewsSuccess(recommendedNews));
          if (recommendedNews.isNotEmpty) {
            emit(HomepageRecommendedNewsSuccess(recommendedNews));
          } else {
            final snapshot = await FirebaseFirestore.instance
                .collection('news')
                .where('country', arrayContains: 'india')
                .where('language', isEqualTo: 'english')
                .orderBy("views", descending: true)
                .limit(20)
                .get();

            recommendedNews = snapshot.docs
                .map((doc) => Article.fromMap(doc.data()))
                .toList();
            emit(HomepageRecommendedNewsSuccess(recommendedNews));
          }
        }
      }
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
          .limit(10)
          .get();

      List<LiveChannelModel> savedChannels = [];

      for (var doc in savedChannelsSnapshot.docs) {
        final channelId = doc.id;

        // Step 2: Fetch channel details from all_channels using the ID
        final channelDoc = await firestore
            .collection('live_chennels')
            .doc('6Kc57CnXtYzg85cD0FXS')
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
          .doc(userId)
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
    String userId;
    try {
      if (AuthService().isUserLoggedIn()) {
        userId = AuthService().getUser()!.uid;
      } else {
        EasyLoading.showInfo("Please login to save articles!");

        return;
      }

      final article = event.articleModel;

      if (article.articleId == null) {
        EasyLoading.showError('Invalid article ID');
        return;
      }
      EasyLoading.show(status: 'Saving article...');
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('saved_articles')
          .doc(article.articleId)
          .set(article.toMap());

      EasyLoading.showSuccess('Article saved successfully!');

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
