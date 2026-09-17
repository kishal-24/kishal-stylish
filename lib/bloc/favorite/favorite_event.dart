import 'package:equatable/equatable.dart';
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object?> get props => [];
}
class LoadFavorites extends FavoriteEvent {
  const LoadFavorites();
}
class AddFavorite extends FavoriteEvent {
  final Map<String, dynamic> product;

  const AddFavorite(this.product);

  @override
  List<Object?> get props => [product];
}


class RemoveFavorite extends FavoriteEvent {
  final int index;

  const RemoveFavorite(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleFavorite extends FavoriteEvent {
  final Map<String, dynamic> product;

  const ToggleFavorite(this.product);

  @override
  List<Object?> get props => [product];
}
class ClearFavorites extends FavoriteEvent {
  const ClearFavorites();
}