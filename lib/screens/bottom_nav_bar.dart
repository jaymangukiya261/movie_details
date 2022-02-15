import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_details/screens/faavorite_screen/favorite.dart';
import 'package:movie_details/screens/home_screen/home_screen.dart';
import 'package:movie_details/screens/search_screen/search_screen.dart';

import 'home_screen/bloc/fetch_home_bloc.dart';

class BottomNavView extends StatefulWidget {
  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  late PersistentTabController _controller;

  List<Widget> _widgetOptions = <Widget>[
    BlocProvider(
      create: (context) => FetchHomeBloc(),
      child: HomeScreen(),
    ),
    SearchPage(),
    ActivityTab(),
  ];
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        iconSize: 26,
        icon: Icon(
          Icons.home,
        ),
        activeColorPrimary: Colors.white,
        title: ("Home"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        iconSize: 28,
        icon: Icon(
          Icons.search,
        ),
        activeColorPrimary: Colors.white,
        title: ("Search"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: Colors.grey,
        icon: Icon(
          Icons.favorite,
        ),
        iconSize: 26,
        activeColorPrimary: Colors.white,
        title: ("Activity"),
      ),
    ];
  }

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PersistentTabView(
        this.context,
        controller: _controller,
        screens: _widgetOptions,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color(0xFF100431),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
