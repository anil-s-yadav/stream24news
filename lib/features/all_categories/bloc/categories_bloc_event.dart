part of 'categories_bloc_bloc.dart';

abstract class CategoriesBlocEvent extends Equatable {}

class CategoriesDataLoadEvent extends CategoriesBlocEvent {
  final String region;
  final String lang;
  final String category;
  CategoriesDataLoadEvent(
      {required this.region, required this.lang, required this.category});
  @override
  List<Object?> get props => [region, lang, category];
}

class CategoriesAscFilter extends CategoriesBlocEvent {
  @override
  List<Object?> get props => [];
}

class CategoriesMostPoFilter extends CategoriesBlocEvent {
  @override
  List<Object?> get props => [];
}
