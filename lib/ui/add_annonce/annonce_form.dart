import 'package:chedmed/blocs/add_annonce_bloc.dart';
import 'package:chedmed/ui/common/inputs.dart';
import 'package:chedmed/ui/common/location_selection.dart';
import 'package:flutter/material.dart';

import '../../models/city.dart';
import '../common/app_theme.dart';
import '../common/select_city.dart';
import '../common/transitions.dart';

class AnnonceForm extends StatefulWidget {
  const AnnonceForm({Key? key}) : super(key: key);

  @override
  State<AnnonceForm> createState() => _AnnonceFormState();
}

class _AnnonceFormState extends State<AnnonceForm> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    addAnnonceBloc.init();
    addAnnonceBloc.getSelectedCity.listen((event) {
      cityController.text = event.name;
    });

    addAnnonceBloc.getDone.listen((event) {
      init();
    });

    super.initState();
  }

  init() {
    titleController.text = "";
    descriptionController.text = "";
    priceController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addAnnonceFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text("Titre",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  controller: titleController,
                  validator: addAnnonceBloc.titleValidator,
                  decoration:
                      MyInputDecoration(title: "Titre", context: context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 3),
                  child: Text("Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                    validator: addAnnonceBloc.descriptionValidator,
                    controller: descriptionController,
                    maxLines: 5,
                    decoration:
                        MyInputDecorationMultiLine("Description", context)),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 3),
                  child: Text("Emplacement",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  validator: addAnnonceBloc.cityValidator,
                  decoration: MyInputDecoration(
                      title: "L'emplacement de l'annonce", context: context),
                  controller: cityController,
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideBottomRoute(
                            widget: SelectCity(
                          title: "L'mplacement de l'annonce",
                          citySelected: addAnnonceBloc.selectCity,
                        )));
                  },
                  readOnly: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 3),
                  child: Text("Prix (DA)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 200),
                  child: TextFormField(
                    controller: priceController,
                    //readOnly: true,
                    //  cursorColor: Colors.white,
                    // focusNode: startFocusNode,
                    validator: addAnnonceBloc.priceValidator,
                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        fillColor: AppTheme.cardColor(context),
                        filled: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
