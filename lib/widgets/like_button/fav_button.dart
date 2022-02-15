import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../constants.dart';
import 'cubit/like_movie_cubit.dart';

InterstitialAd? interstitialAd;

class FavirIcon extends StatelessWidget {
  final String title;
  final String image;
  final String movieid;
  final Color likeColor;
  final Color unLikeColor;
  final String date;
  final double rate;
  final bool isMovie;
  final String backdrop;
  const FavirIcon({
    Key? key,
    required this.title,
    required this.image,
    required this.movieid,
    required this.likeColor,
    required this.unLikeColor,
    required this.date,
    required this.isMovie,
    required this.backdrop,
    required this.rate,
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

    return BlocBuilder<LikeMovieCubit, LikeMovieState>(
      builder: (context, state) {
        // ignore: deprecated_member_use
        return RaisedButton(
          elevation: 0,
          color: Colors.grey.withOpacity(.3),
          onPressed: () {
            interstitialAd!.show();
            BlocProvider.of<LikeMovieCubit>(context).like(
              name: title,
              image: image,
              movieid: movieid,
              rate: rate,
              backdrop: backdrop,
              date: date,
              isMovie: isMovie,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: state.isLikeMovie ? likeColor : unLikeColor,
                size: 30,
              ),
              Text(!state.isLikeMovie ? " Add to Favorite" : " Your Favorite",
                  style: normalText.copyWith(color: unLikeColor))
            ],
          ),
        );
      },
    );
  }
}
