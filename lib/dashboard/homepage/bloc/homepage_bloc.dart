import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../models/live_channel_model.dart';
import '../../../models/new_model.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomepageBloc() : super(HomepageInitialState()) {
    on<HomepageLoadChannelsEvent>(_loadHomePageChannels);
    on<HomepageLoadTrendingEvent>(_loadTrendingNews);
    on<HomepageLoadRecommendedEvent>(_loadRecommendedNews);
  }

  void _loadHomePageChannels(
      HomepageLoadChannelsEvent event, Emitter<HomepageState> emit) async {
    try {
      emit(HomepageLiveChannelLoading());
      // log('Loading channels for region: ${event.region}');
      final snapshot = await FirebaseFirestore.instance
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS')
          .collection('all_channels')
          .get();

      List<LiveChannelModel> allChannels = snapshot.docs
          .map((doc) => LiveChannelModel.fromJson(doc.data()))
          .toList();
      // Filter by region
      List<LiveChannelModel> regionChannels = allChannels
          .where((channel) => channel.region == event.region)
          .toList();
      // Sort by viewCount (highest first)
      // regionChannels.sort((a, b) => b.viewCount.compareTo(a.viewCount));
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
      final snapshot =
          await FirebaseFirestore.instance.collection('news').get();

      List<Article> allNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      // Filter news by country
      List<Article> regionNews = allNews.where((news) {
        return news.country?.contains(event.region.toLowerCase()) ?? false;
      }).toList();

      // Sort by views (highest first)
      regionNews.sort((a, b) => (b.views ?? 0).compareTo(a.views ?? 0));

      // Take top 50
      List<Article> trendingNews = regionNews.take(50).toList();
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
      final snapshot =
          await FirebaseFirestore.instance.collection('news').get();

      List<Article> allNews =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();

      // Filter news by country
      List<Article> regionNews = allNews.where((news) {
        return news.country?.contains(event.region.toLowerCase()) ?? false;
      }).toList();

      // Sort by views (highest first)
      regionNews.sort((a, b) => (b.views ?? 0).compareTo(a.views ?? 0));

      // Take top 50
      List<Article> recommendedNews = regionNews.take(5).toList();
      emit(HomepageRecommendedNewsSuccess(recommendedNews));
    } catch (e) {
      emit(HomepageRecommendedNewsError());
      throw Exception(e);
    }
  }
}
