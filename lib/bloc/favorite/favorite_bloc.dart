import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/favorite_model.dart';

import 'favorite_event.dart';
import 'favorite_state.dart';


class FavoriteBloc
    extends Bloc<FavoriteEvent, FavoriteState> {

  FavoriteBloc()
      : super(const FavoriteInitial()) {

    on<LoadFavorites>(_loadFavorites);
    on<AddFavorite>(_addFavorite);
    on<RemoveFavorite>(_removeFavorite);
    on<ToggleFavorite>(_toggleFavorite);
    on<ClearFavorites>(_clearFavorites);
  }
  static const String _favoriteStorageKey =
      'favorite_items';
  Future<void> _loadFavorites(
      LoadFavorites event,
      Emitter<FavoriteState> emit,
      ) async {

    try {

      emit(const FavoriteLoading());

      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String? savedData =
      prefs.getString(
        _favoriteStorageKey,
      );

      if (savedData == null ||
          savedData.isEmpty) {

        emit(
          const FavoriteLoaded(
            favorites: [],
          ),
        );

        return;
      }

      final dynamic decoded =
      jsonDecode(savedData);

      final List<Map<String, dynamic>>
      favorites = [];

      if (decoded is List) {

        for (final item in decoded) {

          if (item is Map) {

            final FavoriteModel model =
            FavoriteModel.fromMap(
              Map<String, dynamic>.from(
                item,
              ),
            );

            favorites.add(
              model.toMap(),
            );
          }
        }
      }

      emit(
        FavoriteLoaded(
          favorites: favorites,
        ),
      );

    } catch (e) {

      emit(
        const FavoriteError(
          'Failed to load favorites',
        ),
      );
    }
  }


  Future<void> _addFavorite(
      AddFavorite event,
      Emitter<FavoriteState> emit,
      ) async {

    try {

      List<Map<String, dynamic>> favorites = [];

      if (state is FavoriteLoaded) {

        final currentState =
        state as FavoriteLoaded;

        favorites =
        List<Map<String, dynamic>>.from(
          currentState.favorites,
        );
      }


      final bool alreadyExists =
      favorites.any(
            (item) =>
        item['id'].toString() ==
            event.product['id'].toString(),
      );


      if (!alreadyExists) {

        favorites.add(
          Map<String, dynamic>.from(
            event.product,
          ),
        );

      }


      await _saveFavorites(
        favorites,
      );


      emit(
        FavoriteLoaded(
          favorites: favorites,
        ),
      );

    } catch (e) {

      emit(
        const FavoriteError(
          'Failed to add favorite',
        ),
      );
    }
  }
  Future<void> _removeFavorite(
      RemoveFavorite event,
      Emitter<FavoriteState> emit,
      ) async {

    if (state is! FavoriteLoaded) {
      return;
    }

    final currentState =
    state as FavoriteLoaded;

    final List<Map<String, dynamic>>
    favorites =
    List<Map<String, dynamic>>.from(
      currentState.favorites,
    );
    if (event.index < 0 ||
        event.index >= favorites.length) {
      return;
    }
    favorites.removeAt(
      event.index,
    );


    await _saveFavorites(
      favorites,
    );


    emit(
      FavoriteLoaded(
        favorites: favorites,
      ),
    );
  }


  // ==========================================================
  // TOGGLE FAVORITE
  // ==========================================================

  Future<void> _toggleFavorite(
      ToggleFavorite event,
      Emitter<FavoriteState> emit,
      ) async {

    List<Map<String, dynamic>> favorites = [];

    if (state is FavoriteLoaded) {

      final currentState =
      state as FavoriteLoaded;

      favorites =
      List<Map<String, dynamic>>.from(
        currentState.favorites,
      );
    }


    final int existingIndex =
    favorites.indexWhere(
          (item) =>
      item['id'].toString() ==
          event.product['id'].toString(),
    );


    if (existingIndex != -1) {

      // Remove
      favorites.removeAt(
        existingIndex,
      );

    } else {

      // Add
      favorites.add(
        Map<String, dynamic>.from(
          event.product,
        ),
      );
    }


    await _saveFavorites(
      favorites,
    );


    emit(
      FavoriteLoaded(
        favorites: favorites,
      ),
    );
  }


  // ==========================================================
  // CLEAR FAVORITES
  // ==========================================================

  Future<void> _clearFavorites(
      ClearFavorites event,
      Emitter<FavoriteState> emit,
      ) async {

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    await prefs.remove(
      _favoriteStorageKey,
    );


    emit(
      const FavoriteLoaded(
        favorites: [],
      ),
    );
  }


  // ==========================================================
  // SAVE FAVORITES
  // ==========================================================

  Future<void> _saveFavorites(
      List<Map<String, dynamic>> favorites,
      ) async {

    final SharedPreferences prefs =
    await SharedPreferences.getInstance();

    final String data =
    jsonEncode(favorites);

    await prefs.setString(
      _favoriteStorageKey,
      data,
    );
  }
}