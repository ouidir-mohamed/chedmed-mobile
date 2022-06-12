import 'package:chedmed/blocs/home_bloc.dart';
import 'package:chedmed/ui/common/app_theme.dart';
import 'package:chedmed/ui/home/filter_dialog/range_selection.dart';
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
  @override
  void initState() {
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: MyElevatedButtonWide(
                      child: Text(
                        "Filtrer",
                      ),
                      color: AppTheme.secondaryColor(context),
                      onPressed: () {
                        homeBloc.validateFilters();
                        Navigator.of(context).pop();
                      },
                    ),
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
    homeBloc.getFiltersEnabled.listen((event) {
      if (mounted)
        setState(() {
          filterEnabled = event;
        });
    });
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
                  Text("Filtres",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      )),
                ],
              ),
              filterEnabled
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MyElevatedButtonSmall(
                        onPressed: () {
                          homeBloc.resetFilters();
                        },
                        child: Row(
                          children: [
                            Icon(
                              FontAwesome.times,
                              size: 17,
                              color: Colors.white,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3)),
                            Text(
                              "Effacer",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        color: AppTheme.primaryColor(context),
                      ),
                    )
                  : Container()
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
            decoration:
                MyInputDecoration(title: "Votre emplacement", context: context),
            controller: cityController,
            onTap: () {
              Navigator.push(
                  context,
                  SlideBottomRoute(
                      widget: SelectCity(
                    title: "Votre emplacement",
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
