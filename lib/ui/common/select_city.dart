import 'package:chedmed/blocs/getting_started_bloc.dart';
import 'package:chedmed/blocs/locations_bloc.dart';
import 'package:chedmed/ui/common/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../models/city.dart';
import 'app_theme.dart';

class SelectCity extends StatefulWidget {
  SelectCity({Key? key, required this.citySelected, required this.title})
      : super(key: key);
  String title;
  Function(City) citySelected;
  @override
  _SelectCityState createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  List<City> suggestedCities = [];
  TextEditingController cityController = new TextEditingController();

  @override
  void initState() {
    locationsBloc.getAllCities.listen((s) {
      suggestedCities = s;
    });

    locationsBloc.getFoundCity.listen((event) {
      widget.citySelected(event);
      closeDialog();
    });
    super.initState();
  }

  closeDialog() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Autocomplete<City>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<City>.empty();
                          }
                          return suggestedCities.where((option) {
                            return option.name
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController fieldTextEditingController,
                            FocusNode fieldFocusNode,
                            VoidCallback onFieldSubmitted) {
                          fieldFocusNode.requestFocus();
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: MyInputDecoration(
                                      title: widget.title,
                                      // "Votre emplacement",
                                      context: context,
                                    ),
                                    controller: fieldTextEditingController,
                                    focusNode: fieldFocusNode,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 2),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    child: Container(
                                      color: AppTheme.cardColor(context),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            locationsBloc
                                                .requestCurrentLocation();
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Icon(
                                                Icons.location_searching_sharp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<City> onSelected,
                            Iterable<City> options) {
                          return Container(
                            //  width: 300,
                            color: Colors.transparent,
                            margin: const EdgeInsets.symmetric(horizontal: 20),

                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final City option = options.elementAt(index);

                                return Material(
                                  color: AppTheme.cardColor(context),
                                  child: InkWell(
                                    onTap: () {
                                      print("selected");
                                      onSelected(option);
                                      widget.citySelected(option);
                                      closeDialog();
                                    },
                                    child: ListTile(
                                      title: Text(
                                        option.name,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        //   onSelected: (City selection) {},
                      ),
                    ]))));
  }
}
