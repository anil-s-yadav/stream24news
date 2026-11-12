import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/auth/auth_service.dart';

import '../../../models/live_channel_model.dart';
import '../../../models/new_model.dart';
import '../../../utils/services/firestore_cache_service.dart';
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
      final cache = FirestoreCacheService();
      final channelsRef = FirebaseFirestore.instance
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS')
          .collection('all_channels');

      final snapshot = await cache.getQueryWithCache(
        query: channelsRef
            .where("region", isEqualTo: region[2])
            .orderBy("viewCount", descending: true)
            .limit(20),
        cacheKey: 'home_channels_${region[2]}',
        ttl: FirestoreCacheService.channelsTtl,
      );

      List<LiveChannelModel> regionChannels = snapshot.docs
          .map((doc) => LiveChannelModel.fromFirestore(doc))
          .toList();

      if (regionChannels.isEmpty) {
        final snapshot = await cache.getQueryWithCache(
          query: channelsRef.orderBy("viewCount", descending: true).limit(20),
          cacheKey: 'home_channels_global',
          ttl: FirestoreCacheService.channelsTtl,
        );

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
      final cache = FirestoreCacheService();
      final newsRef = FirebaseFirestore.instance.collection('news');

      final snapshot = await cache.getQueryWithCache(
        query: newsRef
            .where('country', arrayContains: country)
            .where('language', isEqualTo: language)
            .orderBy('pubDate', descending: true),
        cacheKey: 'home_latest_${country}_$language',
        ttl: FirestoreCacheService.newsTtl,
      );

      latestNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      if (latestNews.isNotEmpty) {
        emit(HomepageLatestNewsSuccess(latestNews));
      } else {
        final snapshot = await cache.getQueryWithCache(
          query: newsRef
              .where('country', arrayContains: country)
              .orderBy('pubDate', descending: true),
          cacheKey: 'home_latest_country_$country',
          ttl: FirestoreCacheService.newsTtl,
        );

        latestNews =
            snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
        if (latestNews.isNotEmpty) {
          emit(HomepageLatestNewsSuccess(latestNews));
        } else {
          final snapshot = await cache.getQueryWithCache(
            query: newsRef
                .where('language', isEqualTo: language)
                .orderBy('pubDate', descending: true),
            cacheKey: 'home_latest_lang_$language',
            ttl: FirestoreCacheService.newsTtl,
          );

          latestNews =
              snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

          if (latestNews.isNotEmpty) {
            emit(HomepageLatestNewsSuccess(latestNews));
          } else {
            final snapshot = await cache.getQueryWithCache(
              query: newsRef
                  .where('country', arrayContains: 'india')
                  .where('language', isEqualTo: 'english')
                  .orderBy('pubDate', descending: true),
              cacheKey: 'home_latest_india_english',
              ttl: FirestoreCacheService.newsTtl,
            );

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
      final cache = FirestoreCacheService();
      final newsRef = FirebaseFirestore.instance.collection('news');

      final snapshot = await cache.getQueryWithCache(
        query: newsRef
            .where('country', arrayContains: country)
            .where('language', isEqualTo: language)
            .orderBy("views", descending: true)
            .limit(20),
        cacheKey: 'home_rec_${country}_$language',
        ttl: FirestoreCacheService.newsTtl,
      );

      recommendedNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      if (recommendedNews.isNotEmpty) {
        emit(HomepageRecommendedNewsSuccess(recommendedNews));
      } else {
        final snapshot = await cache.getQueryWithCache(
          query: newsRef
              .where('country', arrayContains: country)
              .orderBy("views", descending: true)
              .limit(20),
          cacheKey: 'home_rec_country_$country',
          ttl: FirestoreCacheService.newsTtl,
        );

        recommendedNews =
            snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
        if (recommendedNews.isNotEmpty) {
          emit(HomepageRecommendedNewsSuccess(recommendedNews));
        } else {
          final snapshot = await cache.getQueryWithCache(
            query: newsRef
                .where('language', isEqualTo: 'english')
                .orderBy("views", descending: true)
                .limit(20),
            cacheKey: 'home_rec_lang_english',
            ttl: FirestoreCacheService.newsTtl,
          );

          recommendedNews =
              snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
          if (recommendedNews.isNotEmpty) {
            emit(HomepageRecommendedNewsSuccess(recommendedNews));
          } else {
            final snapshot = await cache.getQueryWithCache(
              query: newsRef
                  .where('country', arrayContains: 'india')
                  .where('language', isEqualTo: 'english')
                  .orderBy("views", descending: true)
                  .limit(20),
              cacheKey: 'home_rec_india_english',
              ttl: FirestoreCacheService.newsTtl,
            );

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
      final cache = FirestoreCacheService();

      // Step 1: Get all saved channel IDs for the user
      final savedChannelsSnapshot = await cache.getQueryWithCache(
        query: firestore
            .collection('user')
            .doc(userId)
            .collection('saved_channels')
            .limit(10),
        cacheKey: 'homepage_saved_channels_$userId',
        ttl: FirestoreCacheService.savedListTtl,
      );

      List<LiveChannelModel> savedChannels = [];

      for (var doc in savedChannelsSnapshot.docs) {
        final channelId = doc.id;

        // Step 2: Fetch channel details from cache first, then server
        final channelDoc = await cache.getDocumentWithCache(
          firestore
              .collection('live_chennels')
              .doc('6Kc57CnXtYzg85cD0FXS')
              .collection('all_channels')
              .doc(channelId),
        );

        if (channelDoc.exists) {
          savedChannels.add(LiveChannelModel.fromFirestore(channelDoc));
        }
      }

      // Step 3: Get all saved article IDs for the user
      final savedArticlesSnapshot = await cache.getQueryWithCache(
        query: firestore
            .collection('user')
            .doc(userId)
            .collection('saved_articles')
            .limit(10),
        cacheKey: 'homepage_saved_articles_$userId',
        ttl: FirestoreCacheService.savedListTtl,
      );
      List<Article> savedArticles = [];
      for (var doc in savedArticlesSnapshot.docs) {
        final articleId = doc.id;

        // Step 4: Fetch article details from cache first, then server
        final articleDoc = await cache.getDocumentWithCache(
          firestore.collection('news').doc(articleId),
        );

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
      await FirestoreCacheService().invalidate('saved_articles_$userId');
      await FirestoreCacheService()
          .invalidate('homepage_saved_articles_$userId');

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
