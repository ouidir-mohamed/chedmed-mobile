import 'package:chedmed/ui/add_annonce/add_annonce.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/home/home.dart';
import 'package:chedmed/ui/profile/profile.dart';
import 'package:chedmed/ui/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: navigationController,
      screens: _buildScreens(),
      items: _navBarsItems(context),
      confineInSafeArea: true,
      backgroundColor:
          AppTheme.containerColor(context), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0.0),
        colorBehindNavBar: AppTheme.containerColor(context),
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style12, // Choose the nav bar style with this property.
    );
  }
}

List<Widget> _buildScreens() {
  return [HomePage(), AddAnnonce(), Profile(), SettingsScreen()];
}

List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
  return [
    PersistentBottomNavBarItem(
      icon: Icon(CupertinoIcons.home),
      title: ("Découvrir"),
      activeColorPrimary: AppTheme.textColor(context),
      inactiveColorPrimary: CupertinoColors.systemGrey,
      //activeColorSecondary: Colors.white
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        FontAwesome.plus_square_o,
      ),
      iconSize: 28,
      title: ("Ajouter"),
      activeColorPrimary: AppTheme.textColor(context),
      inactiveColorPrimary: CupertinoColors.systemGrey,
      //activeColorSecondary: Colors.white
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Ionicons.person),
      title: ("Profile"),
      activeColorPrimary: AppTheme.textColor(context),
      inactiveColorPrimary: CupertinoColors.systemGrey,
      //activeColorSecondary: Colors.white
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Ionicons.ios_settings_outline),
      title: ("Paramètres"),
      activeColorPrimary: AppTheme.textColor(context),
      inactiveColorPrimary: CupertinoColors.systemGrey,
      //activeColorSecondary: Colors.white
    ),
  ];
}

PersistentTabController navigationController = PersistentTabController();
