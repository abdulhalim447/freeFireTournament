import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tournament_app/screens/home_screen.dart';
import 'package:tournament_app/screens/my_matches.dart';
import 'package:tournament_app/screens/profile/profile_screen.dart';
import 'package:tournament_app/screens/reslut_screen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  List<Widget> _buildScreens() {
    return [HomeScreen(), MyMatchesScreen(), ResultScreen(), ProfileScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Image.asset("assets/icons/game.png"),
        title: (" Play"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset("assets/icons/matches.png"),
        title: ("My Matches"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset("assets/icons/results.png"),
        title: ("Results"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset("assets/icons/profile.png"),
        title: ("Profile"),
        activeColorPrimary: Colors.indigo,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      //confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: 60,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(16.0),
        colorBehindNavBar: Colors.white,
      ),
      //popAllScreensOnTapOfSelectedTab: true,
      //popActionScreens: PopActionScreensType.all,
      navBarStyle: NavBarStyle.style3, // Customize this to your design
    );
  }
}
