part of 'newspage_bloc.dart';

abstract class NewspageState extends Equatable {}

final class NewspageInitial extends NewspageState {
  @override
  List<Object?> get props => [];
}

final class NewspageLoading extends NewspageState {
  @override
  List<Object?> get props => [];
}

final class NewspageSuccess extends NewspageState {
  final List<Article> articles;

  NewspageSuccess({required this.articles});

  @override
  List<Object?> get props => [articles];
}

final class NewspageError extends NewspageState {
  @override
  List<Object?> get props => [];
}
