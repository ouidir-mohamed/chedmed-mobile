import 'package:chedmed/blocs/profile_bloc.dart';
import 'package:chedmed/ui/common/inputs.dart';
import 'package:chedmed/utils/language_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

import 'package:chedmed/ui/profile/user_informations.dart.dart';

import '../../models/profile.dart';
import '../common/app_theme.dart';
import '../common/buttons.dart';

class EditProfileDialog extends StatefulWidget {
  String username;
  String phone;
  EditProfileDialog({
    Key? key,
    required this.username,
    required this.phone,
  }) : super(key: key);

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool loading = false;
  @override
  void initState() {
    userNameController.text = widget.username;
    phoneController.text = widget.phone;

    profileBloc.getEditDone.listen((event) {
      if (mounted) Navigator.of(context).pop();
    });

    profileBloc.getEditLoading.listen((event) {
      if (mounted)
        setState(() {
          loading = event;
        });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).;
    // var width = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: AppTheme.canvasColor(context),
      titlePadding: EdgeInsets.only(top: 18, right: 24, left: 24, bottom: 0),
      contentPadding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(getTranslation.edit),
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Entypo.edit),
              ),
            ],
          ),
          Container(
            height: 0.1,
            width: double.infinity,
            color: Colors.grey,
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            width: 9000,
            child: Stack(
              children: [
                Form(
                  key: profileFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 20),
                        child: Text(getTranslation.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      TextFormField(
                        controller: userNameController,
                        validator: profileBloc.nameValidator,
                        //readOnly: true,
                        //  cursorColor: Colors.white,
                        // focusNode: startFocusNode,

                        decoration: MyInputDecoration(
                            title: getTranslation.your_name, context: context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 20),
                        child: Text(getTranslation.phone,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      TextFormField(
                        controller: phoneController,
                        validator: profileBloc.phoneValidator,

                        //readOnly: true,
                        //  cursorColor: Colors.white,
                        // focusNode: startFocusNode,

                        decoration: MyInputDecoration(
                            title: getTranslation.your_phone, context: context),
                      ),
                      Container(
                        height: 50,
                      ),
                      Container(
                        height: 0.1,
                        width: double.infinity,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
                loading
                    ? Positioned(
                        bottom: 0,
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          color: AppTheme.canvasColor(context),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Container()
              ],
            )),
      ),
      actions: <Widget>[
        MyTextButton(
          onPressed: () => Navigator.pop(context, 'Annuler'),
          child: Text(getTranslation.cancel),
        ),
        MyTextButton(
          onPressed: loading
              ? () {}
              : () {
                  profileBloc.editProfile();
                },
          child: Text(getTranslation.edit),
        ),
      ],
    );
  }
}

displayEditDialog(BuildContext context, String userName, String phone) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => EditProfileDialog(
            username: userName,
            phone: phone,
          ));
}
