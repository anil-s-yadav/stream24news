part of 'categories_bloc_bloc.dart';

abstract class CategoriesBlocState extends Equatable {}

final class CategoriesBlocInitial extends CategoriesBlocState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class CategoriesBlocLoading extends CategoriesBlocState {
  @override
  List<Object?> get props => [];
}

final class CategoriesBlocSuccess extends CategoriesBlocState {
  final List<Article> articalModel;

  CategoriesBlocSuccess({required this.articalModel});

  @override
  List<Object?> get props => [articalModel];
}

final class CategoriesBlocError extends CategoriesBlocState {
  @override
  List<Object?> get props => [];
}
