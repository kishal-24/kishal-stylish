import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}
class FavoriteInitial extends FavoriteState {
  const FavoriteInitial();
}
class FavoriteLoading extends FavoriteState {
  const FavoriteLoading();
}
class FavoriteLoaded extends FavoriteState {
  final List<Map<String, dynamic>> favorites;

  const FavoriteLoaded({
    this.favorites = const [],
  });

  FavoriteLoaded copyWith({
    List<Map<String, dynamic>>? favorites,
  }) {
    return FavoriteLoaded(
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
    favorites,
  ];
}
class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [
    message,
  ];
}