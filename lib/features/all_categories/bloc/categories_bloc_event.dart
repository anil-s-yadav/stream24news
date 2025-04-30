part of 'categories_bloc_bloc.dart';

abstract class CategoriesBlocEvent extends Equatable {}

class CategoriesDataLoadEvent extends CategoriesBlocEvent {
  final String region;
  final String lang;
  CategoriesDataLoadEvent({required this.region, required this.lang});
  @override
  List<Object?> get props => [region, lang];
}
