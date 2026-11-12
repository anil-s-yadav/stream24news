import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/models/live_channel_model.dart';
import 'package:stream24news/models/new_model.dart';

import '../../../auth/auth_service.dart';
import '../../../utils/services/firestore_cache_service.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(BookmarkInitial()) {
    on<LoadSavedArticlesEvent>(_loadSavedArticalsEvent);
    on<LoadSavedChannelsEvent>(_loadSavedChannelsEvent);
    on<DeleteSavedChannelEvent>(_deleteSavedChannelEvent);
    on<DeleteSavedArticleEvent>(_deleteSavedArticleEvent);
  }
}

void _loadSavedArticalsEvent(
    LoadSavedArticlesEvent event, Emitter<BookmarkState> emit) async {
  emit(BookmarkArticleLoading());
  String userId;
  try {
    if (AuthService().isUserLoggedIn()) {
      userId = AuthService().getUser()!.uid;
    } else {
      emit(BookmarkArticleError());
      return;
    }
    // String testUserID = "w5PvxpVRTiWlUmb3GJ8SrYBFA9L2";
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final cache = FirestoreCacheService();

    // Get all saved article IDs for the user
    final savedArticlesSnapshot = await cache.getQueryWithCache(
      query: firestore
          .collection('user')
          .doc(userId)
          .collection('saved_articles'),
      cacheKey: 'saved_articles_$userId',
      ttl: FirestoreCacheService.savedListTtl,
    );
    List<Article> savedArticles = [];
    for (var doc in savedArticlesSnapshot.docs) {
      final articleId = doc.id;

      // Fetch article details from cache first, then server
      final articleDoc = await cache.getDocumentWithCache(
        firestore.collection('news').doc(articleId),
      );

      if (articleDoc.exists) {
        savedArticles.add(Article.fromMap(articleDoc.data()!));
      }
    }
    emit(BookmarkArticleSuccess(savedArticles: savedArticles));
  } catch (e) {
    emit(BookmarkArticleError());
  }
}

void _loadSavedChannelsEvent(
    LoadSavedChannelsEvent event, Emitter<BookmarkState> emit) async {
  emit(BookmarkChannelLoading());
  String userId;
  try {
    if (AuthService().isUserLoggedIn()) {
      userId = AuthService().getUser()!.uid;
    } else {
      emit(BookmarkChannelError());
      return;
    }
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final cache = FirestoreCacheService();
    // Get all saved channel IDs for the user
    final savedChannelsSnapshot = await cache.getQueryWithCache(
      query: firestore
          .collection('user')
          .doc(userId)
          .collection('saved_channels'),
      cacheKey: 'saved_channels_$userId',
      ttl: FirestoreCacheService.savedListTtl,
    );

    List<LiveChannelModel> savedChannels = [];

    for (var doc in savedChannelsSnapshot.docs) {
      final channelId = doc.id;

      // Fetch channel details from cache first, then server
      final channelDoc = await cache.getDocumentWithCache(
        firestore
            .collection('live_chennels')
            .doc('6Kc57CnXtYzg85cD0FXS') //  hardcoded  document ID
            .collection('all_channels')
            .doc(channelId),
      );

      if (channelDoc.exists) {
        savedChannels.add(LiveChannelModel.fromFirestore(channelDoc));
      }
    }
    emit(BookmarkChannelSuccess(savedChannels: savedChannels));
  } catch (e) {
    emit(BookmarkChannelError());
  }
}

void _deleteSavedArticleEvent(
    DeleteSavedArticleEvent event, Emitter<BookmarkState> emit) async {
  String userId;
  try {
    EasyLoading.show(status: 'Deleting article...');
    if (AuthService().isUserLoggedIn()) {
      userId = AuthService().getUser()!.uid;
    } else {
      emit(BookmarkArticleError());
      return;
    }
    // String testUserID = "w5PvxpVRTiWlUmb3GJ8SrYBFA9L2";//
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Delete the article from saved articles
    await firestore
        .collection('user')
        .doc(userId)
        .collection('saved_articles')
        .doc(event.articleId)
        .delete();
    await FirestoreCacheService().invalidate('saved_articles_$userId');
    await FirestoreCacheService().invalidate('homepage_saved_articles_$userId');
    EasyLoading.showSuccess('Article deleted successfully');
  } catch (e) {
    EasyLoading.showError('Failed to delete article');
  }
}

void _deleteSavedChannelEvent(
    DeleteSavedChannelEvent event, Emitter<BookmarkState> emit) async {
  String userId;
  try {
    EasyLoading.show(status: 'Deleting channel...');
    if (AuthService().isUserLoggedIn()) {
      userId = AuthService().getUser()!.uid;
    } else {
      emit(BookmarkChannelError());
      return;
    }
    // String testUserID = "w5PvxpVRTiWlUmb3GJ8SrYBFA9L2";
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Delete the channel from saved channels
    await firestore
        .collection('user')
        .doc(userId)
        .collection('saved_channels')
        .doc(event.channelId)
        .delete();
    await FirestoreCacheService().invalidate('saved_channels_$userId');
    await FirestoreCacheService().invalidate('homepage_saved_channels_$userId');
    EasyLoading.showSuccess('Channel deleted successfully');
  } catch (e) {
    EasyLoading.showError('Failed to delete channel');
  }
}
