import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:pet_feeder_v2/screens/fragment_feed.dart';
import 'package:pet_feeder_v2/screens/fragment_home.dart';
import 'package:pet_feeder_v2/screens/fragment_profile.dart';
import 'package:pet_feeder_v2/styles.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  var _controller = PersistentTabController(initialIndex: 0);
  var hasLoggedIn = false;

  final pageList = [
    FragmentHome(),
    FragmentFeed(),
    FragmentProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(context,
        screens: pageList,
        items: _navBarsItems(),
        controller: _controller,
        backgroundColor: Colors.white,
        navBarStyle: NavBarStyle.style15);
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColorPrimary: accentColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Image.asset('assets/images/buttonfeed.png'),
        title: "Feed",
        activeColorPrimary: accentColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: accentColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
