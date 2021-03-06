import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:movie_details/data/fetch_color_palette.dart';
import 'package:movie_details/data/fetch_movie_data_by_id.dart';
import 'package:movie_details/models/error_model.dart';
import 'package:movie_details/models/movie_model.dart';

part 'movie_info_event.dart';
part 'movie_info_state.dart';

class MovieInfoBloc extends Bloc<MovieInfoEvent, MovieInfoState> {
  MovieInfoBloc() : super(MovieInfoInitial());

  final ColorGenrator colorRepo = ColorGenrator();
  final repo = FetchMovieDataById();
  @override
  Stream<MovieInfoState> mapEventToState(
    MovieInfoEvent event,
  ) async* {
    if (event is LoadMoviesInfo) {
      try {
        yield MovieInfoLoading();
        final List<dynamic> info = await repo.getDetails(event.id);
        // final List<Color> color = await colorRepo
        //     .getImagePalette(Image.network(info[0].backdrops).image);
        yield MovieInfoLoaded(
          imdbData: info[4],
          trailers: info[1],
          backdrops: info[2],
          tmdbData: info[0],
          cast: info[3],
          similar: info[5],
        );
      } on FetchDataError catch (e) {
        print(e.toString());
        yield MovieInfoError(error: e);
      } catch (e) {
        yield MovieInfoError(error: FetchDataError(e.toString()));

        print(e.toString());
      }
    }
  }
}
