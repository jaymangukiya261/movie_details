import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:movie_details/constants.dart';
import 'package:movie_details/models/movie_model.dart';
import 'package:movie_details/models/tv_model.dart';
import 'package:movie_details/screens/home_screen/bloc/fetch_home_bloc.dart';
import 'package:movie_details/widgets/header_text.dart';
import 'package:movie_details/widgets/horizontal_list_cards.dart';
import 'package:movie_details/widgets/intro_widget.dart';

import 'package:movie_details/widgets/no_results_found.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FetchHomeBloc homeBloc;
  InterstitialAd? interstitialAd;
  @override
  void initState() {
    homeBloc = BlocProvider.of<FetchHomeBloc>(context);
    homeBloc.add(FetchHomeData());
    super.initState();
  }

  @override
  void dispose() {
    homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            this.interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.black,
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: BlocBuilder<FetchHomeBloc, FetchHomeState>(
            builder: (context, state) {
              if (state is FetchHomeLoaded)
                return HomeScreenWidget(
                  topRated: state.topRated,
                  topShows: state.topShows,
                  nowPlaying: state.nowPlaying,
                  tvShows: state.topShows,
                  tranding: state.tranding,
                  upcoming: state.upcoming,
                );
              else if (state is FetchHomeError)
                return ErrorPage();
              else if (state is FetchHomeLoading)
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );

              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  final List<MovieModel> tranding;
  final List<MovieModel> topRated;
  final List<TvModel> tvShows;
  final List<TvModel> topShows;
  final List<MovieModel> upcoming;
  final List<MovieModel> nowPlaying;
  const HomeScreenWidget({
    Key? key,
    required this.tranding,
    required this.topRated,
    required this.tvShows,
    required this.topShows,
    required this.upcoming,
    required this.nowPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 550,
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.bottomCenter,
                    begin: Alignment.bottomCenter,
                    colors: [
                      scaffoldColor.withOpacity(.5),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  dragStartBehavior: DragStartBehavior.start,
                  physics:
                      BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                  children: [
                    for (var i = 0; i < tranding.length; i++)
                      Center(
                        child: IntroContainer(
                          tranding: tranding[i],
                        ),
                      ),
                  ],
                ),
              ),
              HeaderText(text: "In Theaters"),
              HorizontalListViewMovies(
                list: tranding,
              ),
              HeaderText(text: "Tv shows"),
              HorizontalListViewTv(
                list: tvShows,
              ),
              HeaderText(text: "Top Rated"),
              HorizontalListViewMovies(
                list: topRated,
              ),
              HeaderText(text: "Top rated Tv shows"),
              HorizontalListViewTv(
                list: topShows,
              ),
              HeaderText(text: "Upcoming"),
              HorizontalListViewMovies(
                list: upcoming,
              ),
              HeaderText(text: "Now playing"),
              HorizontalListViewMovies(
                list: nowPlaying,
              )
            ],
          ),
        ),
      ),
    );
  }
}
