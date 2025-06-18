part of 'newspage_bloc.dart';

abstract class NewspageEvent extends Equatable {}

final class NewspageLoadEvent extends NewspageEvent {
  @override
  List<Object?> get props => [];
}

final class NewspageLatest extends NewspageEvent {
  @override
  List<Object?> get props => [];
}

final class NewspageRecomanded extends NewspageEvent {
  @override
  List<Object?> get props => [];
}

final class NewspageSelectCategory extends NewspageEvent {
  final String category;
  NewspageSelectCategory({required this.category});
  @override
  List<Object?> get props => [category];
}
