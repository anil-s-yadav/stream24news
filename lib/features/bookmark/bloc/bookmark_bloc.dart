import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/models/live_channel_model.dart';
import 'package:stream24news/models/new_model.dart';

import '../../../auth/auth_service.dart';

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

    // Get all saved article IDs for the user
    final savedArticlesSnapshot = await firestore
        .collection('user')
        .doc(userId)
        .collection('saved_articles')
        .get();
    List<Article> savedArticles = [];
    for (var doc in savedArticlesSnapshot.docs) {
      final articleId = doc.id;

      // Fetch article details from news using the ID
      final articleDoc =
          await firestore.collection('news').doc(articleId).get();

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
    // Get all saved channel IDs for the user
    final savedChannelsSnapshot = await firestore
        .collection('user')
        .doc(userId)
        .collection('saved_channels')
        .get();

    List<LiveChannelModel> savedChannels = [];

    for (var doc in savedChannelsSnapshot.docs) {
      final channelId = doc.id;

      // Fetch channel details from all_channels using the ID
      final channelDoc = await firestore
          .collection('live_chennels')
          .doc('6Kc57CnXtYzg85cD0FXS') //  hardcoded  document ID
          .collection('all_channels')
          .doc(channelId)
          .get();

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
    EasyLoading.showSuccess('Channel deleted successfully');
  } catch (e) {
    EasyLoading.showError('Failed to delete channel');
  }
}
