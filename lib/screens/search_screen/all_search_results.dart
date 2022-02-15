import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_details/constants.dart';
import 'package:movie_details/models/movie_model.dart';
import 'package:movie_details/models/people_model.dart';
import 'package:movie_details/models/tv_model.dart';
import 'package:movie_details/screens/cast_info_screen/bloc/castinfo_bloc.dart';
import 'package:movie_details/screens/cast_info_screen/cast_info_screen.dart';
import 'package:movie_details/screens/search_screen/bloc/search_results_bloc.dart';

import 'package:movie_details/screens/search_screen/search_results/all_movies_search_results.dart';
import 'package:movie_details/screens/search_screen/search_results/all_people_search_results.dart';
import 'package:movie_details/screens/search_screen/search_results/all_tv_search_results.dart';
import 'package:movie_details/widgets/horizontal_list_cards.dart';
import 'package:movie_details/widgets/no_results_found.dart';

InterstitialAd? interstitialAd;

// ignore: must_be_immutable
class AllSearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
          builder: (context, state) {
            if (state is SearchResultsLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (state is SearchResultsLoaded) {
              return SearchResultsWidget(
                movies: state.movies,
                shows: state.shows,
                showsCount: state.showsCount,
                movieCount: state.moviesCount,
                query: state.query,
                people: state.people,
                peopleCount: state.peopleCount,
              );
            } else if (state is SearchResultsError) {
              return ErrorPage();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class SearchResultsWidget extends StatelessWidget {
  final List<MovieModel> movies;
  final List<TvModel> shows;
  final List<PeopleModel> people;
  final String query;
  final int movieCount;
  final int showsCount;
  final int peopleCount;

  const SearchResultsWidget({
    Key? key,
    required this.movies,
    required this.shows,
    required this.people,
    required this.query,
    required this.movieCount,
    required this.showsCount,
    required this.peopleCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (movies.isEmpty && shows.isEmpty && people.isEmpty)
            Center(child: NoResultsFound()),
          if (movies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: heading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Movies ",
                        ),
                        TextSpan(
                          text: "($movieCount results)",
                          style: heading.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ),
                  if (movieCount > 20)
                    TextButton(
                      onPressed: () {
                        interstitialAd!.show();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AllSearchResultsMovies(
                              query: query,
                              count: movieCount,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "See all",
                        style: normalText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (movies.isNotEmpty) HorizontalListViewMovies(list: movies),
          if (shows.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: heading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Tv Shows ",
                        ),
                        TextSpan(
                          text: "($showsCount results)",
                          style: heading.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ),
                  if (showsCount > 20)
                    TextButton(
                      onPressed: () {
                        interstitialAd!.show();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AllSearchResultsTv(
                              query: query,
                              results: showsCount,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "See all",
                        style: normalText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (shows.isNotEmpty) HorizontalListViewTv(list: shows),
          if (people.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: heading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "People ",
                        ),
                        TextSpan(
                          // ignore: unnecessary_brace_in_string_interps
                          text: "(${peopleCount} results)",
                          style: heading.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ),
                  if (peopleCount > 20)
                    TextButton(
                      onPressed: () {
                        interstitialAd!.show();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchResultsPeople(
                                  query: query,
                                  count: peopleCount,
                                )));
                      },
                      child: Text(
                        "See all",
                        style: normalText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (people.isNotEmpty)
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < people.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: BlocProvider(
                              create: (context) => CastinfoBloc(),
                              child: CastInFoScreen(
                                id: people[i].id,
                                backdrop: people[i].profile,
                              ),
                            ),
                            withNavBar: false,
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(minHeight: 280),
                          child: Column(
                            children: [
                              Container(
                                height: 200,
                                width: 130,
                                color: Colors.black,
                                child: CachedNetworkImage(
                                  imageUrl: people[i].profile,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                width: 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      people[i].name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: normalText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
