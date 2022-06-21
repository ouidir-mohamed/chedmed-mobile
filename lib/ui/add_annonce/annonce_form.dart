import 'package:chedmed/blocs/add_annonce_bloc.dart';
import 'package:chedmed/ui/common/inputs.dart';
import 'package:chedmed/ui/common/location_selection.dart';
import 'package:chedmed/utils/language_helper.dart';
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
  TextEditingController phoneController = TextEditingController();
  bool delivery = false;

  @override
  void initState() {
    addAnnonceBloc.init();
    addAnnonceBloc.getSelectedCity.listen((event) {
      cityController.text = event.name;
    });
    addAnnonceBloc.getProfilePhone.listen((event) {
      phoneController.text = event;
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
                  child: Text(getTranslation.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  controller: titleController,
                  validator: addAnnonceBloc.titleValidator,
                  decoration: MyInputDecoration(
                      title: getTranslation.title, context: context),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(getTranslation.description,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                    validator: addAnnonceBloc.descriptionValidator,
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: MyInputDecorationMultiLine(
                        getTranslation.description, context)),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 3),
                  child: Text(getTranslation.location,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  validator: addAnnonceBloc.cityValidator,
                  decoration: MyInputDecoration(
                      title: getTranslation.post_location, context: context),
                  controller: cityController,
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideBottomRoute(
                            widget: SelectCity(
                          title: getTranslation.post_location,
                          citySelected: addAnnonceBloc.selectCity,
                        )));
                  },
                  readOnly: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 3),
                  child: Text(getTranslation.phone,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  validator: addAnnonceBloc.phoneValidator,
                  decoration: MyInputDecoration(
                      title: getTranslation.phone, context: context),
                  controller: phoneController,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 3),
                  child: Text(getTranslation.price_da,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 3),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                              value: delivery,
                              onChanged: (a) {
                                addAnnonceBloc.delivery = a!;
                                setState(() {
                                  delivery = a;
                                });
                              })),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(getTranslation.with_delivery,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
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
