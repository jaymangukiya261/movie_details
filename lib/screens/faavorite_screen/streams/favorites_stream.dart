import 'dart:async';

import 'package:movie_details/data/fetch_favorite_repo.dart';
import 'package:movie_details/models/favorite_list_model.dart';

class GetFavoritesFromFirebase {
  final StreamController<List<FavoriteWatchListModel>> controller =
      StreamController<List<FavoriteWatchListModel>>();
  final repo = LoadUserCollections();

  var isfinish = false;
  var lastRepo;
  List<FavoriteWatchListModel> movies = [];
  void addData() async {
    final favorites = await repo.getFavorite(null);
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;
    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    lastRepo = favorites[1];
  }

  void getNextMovies() async {
    final favorites = await repo.getFavorite(lastRepo);
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;

    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    if (favorites[1] == null) {
      isfinish = true;
    } else {
      lastRepo = favorites[1];
    }
  }

  void dispose() {
    controller.close();
  }
}
