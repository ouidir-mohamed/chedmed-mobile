import 'package:flutter/material.dart';

import 'app_theme.dart';

@Deprecated("agla3 kan saha")
class LocationSelection extends StatelessWidget {
  const LocationSelection({Key? key}) : super(key: key);
  static const List<String> _kOptions = <String>[
    'aardvark',
    'bobcat',
    'chameleon',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          top: 20,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            child: Text("Emplacement",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return _kOptions.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Votre emplacement",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      fillColor: AppTheme.cardColor(context),
                      filled: true),
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                ),
              );
            },
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options) {
              return Container(
                //  width: 300,
                color: Colors.transparent,
                margin: const EdgeInsets.symmetric(horizontal: 20),

                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);

                    return Material(
                      color: AppTheme.cardColor(context),
                      child: InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(
                            option,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            onSelected: (String selection) {},
          ),
        ]));
  }
}
