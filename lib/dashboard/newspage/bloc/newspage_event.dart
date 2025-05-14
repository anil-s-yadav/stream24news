part of 'newspage_bloc.dart';

abstract class NewspageEvent extends Equatable {}

final class NewspageLoadEvent extends NewspageEvent {
  @override
  List<Object?> get props => [];
}

final class NewspageTrending extends NewspageEvent {
  @override
  List<Object?> get props => [];
}

final class NewspageRecomanded extends NewspageEvent {
  @override
  List<Object?> get props => [];
}

final class NewspageSelectCategory extends NewspageEvent {
  @override
  List<Object?> get props => [];
}
