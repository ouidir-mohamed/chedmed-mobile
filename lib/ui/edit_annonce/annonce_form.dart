import 'package:chedmed/blocs/add_annonce_bloc.dart';
import 'package:chedmed/ui/common/inputs.dart';
import 'package:chedmed/ui/common/location_selection.dart';
import 'package:flutter/material.dart';

import '../../blocs/edit_annonce_bloc.dart';
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
    editAnnonceBloc.getInitialAnnonce.listen((event) {
      if (!mounted) return;
      titleController.text = event.title;
      descriptionController.text = event.description;
      cityController.text = event.location.name;
      phoneController.text = event.phone;
      priceController.text = event.price.toString();

      setState(() {
        delivery = event.delivry;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: editAnnonceFormKey,
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
                  validator: editAnnonceBloc.titleValidator,
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
                    validator: editAnnonceBloc.descriptionValidator,
                    controller: descriptionController,
                    maxLines: 5,
                    decoration:
                        MyInputDecorationMultiLine("Description", context)),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 3),
                  child: Text("Emplacement",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  validator: editAnnonceBloc.cityValidator,
                  decoration: MyInputDecoration(
                      title: "L'emplacement de l'annonce", context: context),
                  controller: cityController,
                  onTap: () {
                    Navigator.push(
                        context,
                        SlideBottomRoute(
                            widget: SelectCity(
                          title: "L'mplacement de l'annonce",
                          citySelected: editAnnonceBloc.selectCity,
                        )));
                  },
                  readOnly: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 3),
                  child: Text("Téléphone",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                TextFormField(
                  validator: editAnnonceBloc.phoneValidator,
                  decoration:
                      MyInputDecoration(title: "Téléphone", context: context),
                  controller: phoneController,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 3),
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
                    validator: editAnnonceBloc.priceValidator,
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
                                editAnnonceBloc.delivery = a!;
                                setState(() {
                                  delivery = a;
                                });
                              })),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text("Avec livraison",
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