import 'package:chedmed/blocs/visitor_profile_bloc.dart';
import 'package:chedmed/ui/visitor_profile/articles_to_display.dart';
import 'package:flutter/material.dart';

import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/visitor_profile/user_informations.dart.dart';

class VisitorProfile extends StatefulWidget {
  int userId;
  VisitorProfile({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<VisitorProfile> createState() => _VisitorProfileState();
}

class _VisitorProfileState extends State<VisitorProfile>
    with TickerProviderStateMixin {
  @override
  void initState() {
    visitorProfileBloc.loadProfileAnnonces(widget.userId, false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.secondaryColor(context),
          onRefresh: () => visitorProfileBloc.refresh(widget.userId),
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                  expandedHeight: 260,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  collapsedHeight: 75,
                  toolbarHeight: 1,
                  shadowColor: Colors.transparent,
                  primary: false,
                  leading: Container(),
                  backgroundColor: Colors.transparent,
                  flexibleSpace: LayoutBuilder(builder: (context, constraints) {
                    return FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        expandedTitleScale: 1,
                        centerTitle: true,
                        titlePadding: EdgeInsets.all(0),
                        background: Column(
                          children: [
                            Header(),
                            UserInfos(
                              userId: widget.userId,
                            )
                          ],
                        ),
                        title: Container(
                            //  child: Filters(),
                            ));
                  })),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  primary: false,
                  child: Container(
                    child: Column(
                      children: [
                        ArticlesToDisplay(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.containerColor(context),
      padding: const EdgeInsets.only(
        top: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReturnButton(transparent: true),
              Text("Kach titre hna",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: AppTheme.textColor(context))),
            ],
          ),
        ],
      ),
    );
  }
}
