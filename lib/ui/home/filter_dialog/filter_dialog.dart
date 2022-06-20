import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/home/filter_dialog/range_selection.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import '../../common/buttons.dart';
import '../../common/inputs.dart';
import '../../common/select_city.dart';
import '../../common/transitions.dart';
import 'categories_selection.dart';
import '../../common/location_selection.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool filterEnabled = false;
  @override
  void initState() {
    homeBloc.getFiltersEnabled.listen((event) {
      if (mounted)
        setState(() {
          filterEnabled = event;
        });
    });
    homeBloc.loadLatestFilters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        // height: double.infinity,
        // color: Colors.red,
        child: new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight, maxHeight: double.infinity),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      Header(),
                      CategoriesSelection(),
                      LocationSelector(),
                      DistanceSelection(),
                      RangeSelection(),
                    ],
                  ),
                  Column(
                    children: [
                      filterEnabled
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: MyOutlinedButtonWide(
                                child: Text(
                                  getTranslation.erease,
                                ),
                                // color: AppTheme.secondaryColor(context),
                                onPressed: () {
                                  homeBloc.resetFilters();
                                },
                              ),
                            )
                          : Container(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: MyElevatedButtonWide(
                          child: Text(
                            getTranslation.filter,
                          ),
                          color: AppTheme.secondaryColor(context),
                          onPressed: () {
                            homeBloc.validateFilters();
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      )),
    );
  }
}

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool filterEnabled = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ReturnButton(
                    transparent: true,
                  ),
                  Text(getTranslation.filters,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DistanceSelection extends StatelessWidget {
  const DistanceSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        //  height: 500,
        );
  }
}

class LocationSelector extends StatefulWidget {
  const LocationSelector({Key? key}) : super(key: key);

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  TextEditingController cityController = TextEditingController();
  @override
  void initState() {
    homeBloc.getCity.listen((event) {
      if (super.mounted) cityController.text = event.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          TextFormField(
            //    validator: addAnnonceBloc.cityValidator,
            decoration: MyInputDecoration(
                title: getTranslation.your_location, context: context),
            controller: cityController,
            onTap: () {
              Navigator.push(
                  context,
                  SlideBottomRoute(
                      widget: SelectCity(
                    title: getTranslation.your_location,
                    citySelected: homeBloc.selectCity,
                  )));
            },
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
