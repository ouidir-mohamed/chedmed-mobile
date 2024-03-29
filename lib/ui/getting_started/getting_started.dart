import 'package:chedmed/blocs/getting_started_bloc.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/common/buttons.dart';
import 'package:chedmed/ui/common/inputs.dart';
import 'package:chedmed/ui/common/location_selection.dart';
import 'package:chedmed/ui/common/transitions.dart';
import 'package:chedmed/ui/common/select_city.dart';
import 'package:chedmed/ui/navigation/bottom_navigation.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/city.dart';

class GettingStarted extends StatefulWidget {
  GettingStarted({Key? key}) : super(key: key);

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  TextEditingController cityController = new TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    gettingStartedBloc.getSelectedCity.listen((event) {
      cityController.text = event.name;
    });

    gettingStartedBloc.getLoading.listen((event) {
      setState(() {
        _loading = event;
      });
    });

    super.initState();
    // WidgetsBinding.instance
    //     ?.addPostFrameCallback((_) => gettingStartedBloc.bypassStart());
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      MyPageViewModel(
          asset: "./assets/name.svg",
          title: getTranslation.your_name,
          body: getTranslation.your_name_desc,
          input: Form(
            key: gettingStartedBloc.nameFormKey,
            child: TextFormField(
              decoration: MyInputDecoration(
                  title: getTranslation.name, context: context),
              validator: gettingStartedBloc.nameValidator,
            ),
          ),
          context: context),
      MyPageViewModel(
          asset: "./assets/phone.svg",
          title: getTranslation.your_phone,
          body: getTranslation.your_phone_desc,
          input: Form(
            key: gettingStartedBloc.numberFormKey,
            child: TextFormField(
              decoration: MyInputDecoration(
                  title: getTranslation.phone, context: context),
              validator: gettingStartedBloc.phoneValidator,
              keyboardType: TextInputType.phone,
            ),
          ),
          context: context),
      MyPageViewModel(
          asset: "./assets/location.svg",
          title: getTranslation.your_location,
          body: getTranslation.your_location_desc,
          input: Form(
            key: gettingStartedBloc.cityFormKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    validator: gettingStartedBloc.cityValidator,
                    onTap: () {
                      Navigator.push(
                          context,
                          SlideBottomRoute(
                              widget: SelectCity(
                            title: getTranslation.your_location,
                            citySelected: gettingStartedBloc.selectCity,
                          )));
                    },
                    readOnly: true,
                    controller: cityController,
                    decoration: MyInputDecoration(
                        title: getTranslation.location, context: context),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.only(left: 3),
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.all(Radius.circular(8)),
                //     child: Container(
                //       color: AppTheme.cardColor(context),
                //       child: Material(
                //         color: Colors.transparent,
                //         child: InkWell(
                //           onTap: () {
                //             gettingStartedBloc.requestCurrentLocation();
                //           },
                //           child: Padding(
                //             padding: EdgeInsets.all(12),
                //             child: Icon(Icons.location_searching_sharp),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          context: context),
      MyPageViewModel(
          asset: "./assets/awesome.svg",
          title: getTranslation.great,
          body: getTranslation.great_desc,
          context: context),
    ];
    return Scaffold(
        body: SafeArea(
      child: IntroductionScreen(
        key: gettingStartedBloc.introKey,
        freeze: true,
        showBackButton: true,
        overrideBack: MyTextButton(
            child: Icon(
              isDirectionRTL(context)
                  ? MaterialIcons.arrow_forward_ios
                  : MaterialIcons.arrow_back_ios,
              color: AppTheme.textColor(context),
            ),
            onPressed: () {
              gettingStartedBloc.handlePrevious();
            }),
        overrideNext: MyTextButton(
          onPressed: () {
            gettingStartedBloc.handleNext();
          },
          child: Text(
            getTranslation.next,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppTheme.primaryColor(context)),
          ),
        ),
        pages: pages,
        overrideDone: MyTextButton(
          onPressed: _loading
              ? () {}
              : () {
                  gettingStartedBloc.handleValidation();
                },
          child: _loading
              ? Container(
                  width: 15, height: 15, child: CircularProgressIndicator())
              : Text(
                  getTranslation.start,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppTheme.primaryColor(context)),
                ),
        ),
        dotsDecorator: DotsDecorator(
          activeColor: AppTheme.primaryColor(context),
        ),
      ),
    ));
  }
}

PageViewModel MyPageViewModel(
    {required String asset,
    required String title,
    required String body,
    Widget? input,
    required BuildContext context}) {
  return PageViewModel(
    titleWidget: Column(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            body,
            style:
                TextStyle(fontSize: 16, color: AppTheme.headlineColor(context)),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
    bodyWidget: input != null ? input : Container(),
    image: SvgPicture.asset(asset, height: 250),
    //footer: LocationSelection(),
    //useScrollView: true,
    decoration: PageDecoration(
        imageFlex: 1,
        titlePadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        imagePadding: EdgeInsets.only(top: 50)),
  );
}
