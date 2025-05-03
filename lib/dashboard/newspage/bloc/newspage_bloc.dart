import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';

import '../../../models/new_model.dart';

part 'newspage_event.dart';
part 'newspage_state.dart';

class NewspageBloc extends Bloc<NewspageEvent, NewspageState> {
  List<String> region = SharedPrefService().getCounty() ??
      ["", "india", "in"]; //["flag", "name", "code"]
  List<String> lang =
      SharedPrefService().getLanguage() ?? ["English", "en"]; //["name", "code"]
  NewspageBloc() : super(NewspageInitial()) {
    on<NewspageLoadEvent>(_loadNewspage);
  }

  void _loadNewspage(
      NewspageLoadEvent event, Emitter<NewspageState> emit) async {
    emit(NewspageLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('news')
          .where('country', arrayContains: region[1].toLowerCase())
          .where('language', isEqualTo: lang[0].toLowerCase())
          .get();

      List<Article> articles =
          snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList();
      log("region: ${region[1]}, lang: ${lang[1]}");
      emit(NewspageSuccess(articles: articles));
    } catch (e) {
      emit(NewspageError());
    }
  }
}
