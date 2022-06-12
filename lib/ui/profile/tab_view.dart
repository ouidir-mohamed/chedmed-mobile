import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chedmed/ui/common/app_theme.dart';

class TabView extends StatelessWidget {
  final TabController tabController;
  TabView({required this.tabController});
  @override
  Widget build(BuildContext context) {
    return TabBar(
        controller: tabController,
        indicatorColor: AppTheme.textColor(context),
        unselectedLabelColor: CupertinoColors.systemGrey,
        labelColor: AppTheme.textColor(context),
        indicatorPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        tabs: [
          Tab(
            text: "Mes annoces",
            iconMargin: EdgeInsets.only(bottom: 5.0),
            icon: Icon(Icons.article),
          ),
          Tab(
            text: "Mes favorites",
            iconMargin: EdgeInsets.only(bottom: 5.0),
            icon: Icon(Icons.favorite),
          )
        ]);
  }
}

class TabViewDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  TabViewDelegate({required this.tabController});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    // TODO: implement build
    return Container(
      color: AppTheme.containerColor(context),
      child: Center(
        child: TabView(tabController: tabController),
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
